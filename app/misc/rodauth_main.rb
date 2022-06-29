class RodauthMain < Rodauth::Rails::Auth
  configure do
    # Список загруженных функций проверки подлинности.
    enable :create_account, :verify_account, :verify_account_grace_period,
           :login, :logout, :remember, :email_auth,
           :reset_password, :change_password, :change_password_notify,
           :change_login, :verify_login_change, :close_account

    # См. документацию Rodauth для получения списка доступных параметров конфигурации:
    # http://rodauth.jeremyevans.net/documentation.html

    # ==> Общий
    # Секретный ключ, используемый для хеширования общедоступных токенов для различных функций.
    # По умолчанию Rails `secret_key_base`, но вы можете использовать свой собственный секретный ключ.
    # hmac_secret "e7c8d1933dafad79441fa8edc9223ddc01186931120fdf808ad2ffab037573a3511fbd53c083608a9c36103b0523bf8d0a092d8557abd59e146163103bd4ed0d"

    # Укажите контроллер, используемый для рендеринга представления и проверки CSRF.
    rails_controller { RodauthController }

    # Установить на контроллере Rodauth заголовок текущей страницы.
    title_instance_variable :@page_title

    # Сохраняем статус учетной записи в целочисленном столбце без ограничения внешнего ключа.
    account_status_column :status

    # Хранить хэш пароля в столбце вместо отдельной таблицы.
    account_password_hash_column :password_hash

    # Установите пароль при создании учетной записи, а не при проверке.
    verify_account_set_password? false

    # Перенаправление обратно в первоначально запрошенное местоположение после аутентификации.
    login_return_to_requested_location? true
    # two_factor_auth_return_to_requested_location? true # if using MFA

    # Автоматический вход пользователя после сброса пароля.
    # reset_password_autologin? true

    # Удалить запись учетной записи, когда пользователь закрыл свою учетную запись.
    delete_account_on_close? true

    # Перенаправление в приложение со страниц входа и регистрации, если вы уже вошли в систему.
    already_logged_in { redirect login_redirect }

    # ==> Электронные письма
    # Используйте собственную почтовую программу для доставки писем с проверкой подлинности.
    create_reset_password_email do
      RodauthMailer.reset_password(*self.class.configuration_name, account_id, reset_password_key_value)
    end
    create_verify_account_email do
      RodauthMailer.verify_account(*self.class.configuration_name, account_id, verify_account_key_value)
    end
    create_verify_login_change_email do |_login|
      RodauthMailer.verify_login_change(*self.class.configuration_name, account_id, verify_login_change_key_value)
    end
    create_password_changed_email do
      RodauthMailer.password_changed(*self.class.configuration_name, account_id)
    end
    # create_email_auth_email do
    #   RodauthMailer.email_auth(*self.class.configuration_name, account_id, email_auth_key_value)
    # end
    # create_unlock_account_email do
    #   RodauthMailer.unlock_account(*self.class.configuration_name, account_id, unlock_account_key_value)
    # end
    send_email do |email|
      # queue email delivery on the mailer after the transaction commits
      db.after_commit { email.deliver_later }
    end

    # ==> Вспышка
    # Сопоставьте флэш-ключи с уже используемыми в приложении Rails.
    # flash_notice_key :success # default is :notice
    # flash_error_key :error # default is :alert

    # Переопределить флэш-сообщения по умолчанию.
    # create_account_notice_flash "Your account has been created. Please verify your account by visiting the confirmation link sent to your email address."
    require_login_error_flash 'Login is required for accessing this page'
    # login_notice_flash nil

    # ==> Проверка
    # Переопределить сообщения об ошибках проверки по умолчанию.
    # no_matching_login_message "user with this email address doesn't exist"
    # already_an_account_with_this_login_message "user with this email address already exists"
    # password_too_short_message { "needs to have at least #{password_minimum_length} characters" }
    # login_does_not_meet_requirements_message { "invalid email#{", #{login_requirement_message}" if login_requirement_message}" }

    # Изменить минимальное количество символов пароля, необходимое при создании учетной записи.
    # password_minimum_length 8

    # ==> Запомнить функцию
    # Запомнить всех зарегистрированных пользователей.
    after_login { remember_login }

    # Или запомните только тех пользователей, которые установили флажок «Запомнить меня» при входе в систему.
    # after_login { remember_login if param_or_nil("remember") }

    # Продлить период запоминания пользователя, когда он запоминается через файл cookie
    extend_remember_deadline? true

    # ==> Хуки
    # Проверка настраиваемых полей в форме создания учетной записи.
    before_create_account do
      # throw_error_status(422, 'username', 'must be present') if param('username').empty?
    end

    # Выполните дополнительные действия после создания учетной записи.
    after_create_account do
      Profile.create!(
        account_id: account_id,
        username: SecureRandom.alphanumeric(20)
      )
    end

    # Выполните дополнительную очистку после закрытия учетной записи.
    after_close_account do
      Profile.find_by!(account_id: account_id).destroy
    end

    # ==> Перенаправления
    # Перенаправление на домашнюю страницу после выхода из системы.
    logout_redirect '/'

    # Перенаправление туда, куда перенаправляется вход после проверки учетной записи.
    verify_account_redirect { login_redirect }

    # Перенаправление на страницу входа после сброса пароля.
    reset_password_redirect { login_path }

    # Убедитесь, что запрос входа в систему следует за изменениями маршрута входа.
    require_login_redirect { login_path }
    
    # ==> Сроки
    # Изменить сроки по умолчанию для некоторых действий.
    # verify_account_grace_period 3.days
    # reset_password_deadline_interval Hash[hours: 6]
    # verify_login_change_deadline_interval Hash[days: 2]
    # remember_deadline_interval Hash[days: 30]

    login_label 'Почта'
    create_account_route 'registration'
  end
end
