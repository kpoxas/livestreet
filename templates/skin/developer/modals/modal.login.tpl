{extends file='modals/modal_base.tpl'}

{block name='options'}
	{assign var='noFooter' value=true}
{/block}

{block name='id'}modal-login{/block}
{block name='class'}modal-login js-modal-default{/block}
{block name='title'}{$aLang.user_authorization}{/block}

{block name='content'}
	<script type="text/javascript">
		jQuery(function($){
			$('#popup-login-form').bind('submit',function(){
				ls.user.login('popup-login-form');
				return false;
			});
			$('#popup-login-form-submit').attr('disabled',false);
		});
	</script>

	<ul class="nav nav-pills" data-type="tabs">
		<li data-type="tab" data-option-target="tab-pane-login"><a href="#">{$aLang.user_login_submit}</a></li>
		{if !$oConfig->GetValue('general.reg.invite')}
			<li data-type="tab" data-option-target="tab-pane-registration"><a href="#">{$aLang.registration}</a></li>
		{else}
			<li><a href="{router page='registration'}">{$aLang.registration}</a></li>
		{/if}
		<li data-type="tab" data-option-target="tab-pane-reminder"><a href="#">{$aLang.password_reminder}</a></li>
	</ul>

	<div data-type="tab-content">
		<div class="tab-pane" id="tab-pane-login" data-type="tab-pane">
			{hook run='login_popup_begin'}
			<form action="{router page='login'}" method="post" id="popup-login-form">
				{hook run='form_login_popup_begin'}

				<p><label for="popup-login">{$aLang.user_login}:</label>
				<input type="text" name="login" id="popup-login" class="input-text input-width-300"></p>

				<p><label for="popup-password">{$aLang.user_password}:</label>
				<input type="password" name="password" id="popup-password" class="input-text input-width-300">
				<small class="validate-error-hide validate-error-login"></small></p>

				<p><label><input type="checkbox" name="remember" class="input-checkbox" checked> {$aLang.user_login_remember}</label></p>

				{hook run='form_login_popup_end'}

				<input type="hidden" name="return-path" value="{$PATH_WEB_CURRENT}">
				<button type="submit" name="submit_login" class="button button-primary" id="popup-login-form-submit" disabled="disabled">{$aLang.user_login_submit}</button>
			</form>
			{hook run='login_popup_end'}
		</div>


		{if !$oConfig->GetValue('general.reg.invite')}
		<div class="tab-pane" id="tab-pane-registration" data-type="tab-pane">
			<script type="text/javascript">
				jQuery(document).ready(function($){
					$('#popup-registration-form').find('input.js-ajax-validate').blur(function(e){
						var aParams={ };
						if ($(e.target).attr('name')=='password_confirm') {
							aParams['password']=$('#popup-registration-user-password').val();
						}
						if ($(e.target).attr('name')=='password') {
							aParams['password']=$('#popup-registration-user-password').val();
							if ($('#popup-registration-user-password-confirm').val()) {
								ls.user.validateRegistrationField('password_confirm',$('#popup-registration-user-password-confirm').val(),$('#popup-registration-form'),{ 'password': $(e.target).val() });
							}
						}
						ls.user.validateRegistrationField($(e.target).attr('name'),$(e.target).val(),$('#popup-registration-form'),aParams);
					});
					$('#popup-registration-form').bind('submit',function(){
						ls.user.registration('popup-registration-form');
						return false;
					});
					$('#popup-registration-form-submit').attr('disabled',false);
				});
			</script>

			{hook run='registration_begin' isPopup=true}
			<form action="{router page='registration'}" method="post" id="popup-registration-form">
				{hook run='form_registration_begin' isPopup=true}

				<p><label for="popup-registration-login">{$aLang.registration_login}</label>
				<input type="text" name="login" id="popup-registration-login" value="{$_aRequest.login}" class="input-text input-width-300 js-ajax-validate" />
				<i class="icon-ok-green validate-ok-field-login" style="display: none"></i>
				<i class="icon-question-sign js-tip-help" title="{$aLang.registration_login_notice}"></i>
				<small class="validate-error-hide validate-error-field-login"></small></p>

				<p><label for="popup-registration-mail">{$aLang.registration_mail}</label>
				<input type="text" name="mail" id="popup-registration-mail" value="{$_aRequest.mail}" class="input-text input-width-300 js-ajax-validate" />
				<i class="icon-ok-green validate-ok-field-mail" style="display: none"></i>
				<i class="icon-question-sign js-tip-help" title="{$aLang.registration_mail_notice}"></i>
				<small class="validate-error-hide validate-error-field-mail"></small></p>

				<p><label for="popup-registration-user-password">{$aLang.registration_password}</label>
				<input type="password" name="password" id="popup-registration-user-password" value="" class="input-text input-width-300 js-ajax-validate" />
				<i class="icon-ok-green validate-ok-field-password" style="display: none"></i>
				<i class="icon-question-sign js-tip-help" title="{$aLang.registration_password_notice}"></i>
				<small class="validate-error-hide validate-error-field-password"></small></p>

				<p><label for="popup-registration-user-password-confirm">{$aLang.registration_password_retry}</label>
				<input type="password" value="" id="popup-registration-user-password-confirm" name="password_confirm" class="input-text input-width-300 js-ajax-validate" />
				<i class="icon-ok-green validate-ok-field-password_confirm" style="display: none"></i>
				<small class="validate-error-hide validate-error-field-password_confirm"></small></p>

				{hookb run="popup_registration_captcha"}
				<p><label for="popup-registration-captcha">{$aLang.registration_captcha}</label>
				<img src="{cfg name='path.root.engine_lib'}/external/kcaptcha/index.php?{$_sPhpSessionName}={$_sPhpSessionId}"
					 onclick="this.src='{cfg name='path.root.engine_lib'}/external/kcaptcha/index.php?{$_sPhpSessionName}={$_sPhpSessionId}&n='+Math.random();"
					 class="captcha-image" />
				<input type="text" name="captcha" id="popup-registration-captcha" value="" maxlength="3" class="input-text input-width-100 js-ajax-validate" />
				<small class="validate-error-hide validate-error-field-captcha"></small></p>
				{/hookb}

				{hook run='form_registration_end' isPopup=true}

				<input type="hidden" name="return-path" value="{$PATH_WEB_CURRENT}">
				<button type="submit" name="submit_register" class="button button-primary" id="popup-registration-form-submit" disabled="disabled">{$aLang.registration_submit}</button>
			</form>
			{hook run='registration_end' isPopup=true}
		</div>
		{/if}


		<div class="tab-pane" id="tab-pane-reminder" data-type="tab-pane">
			<script type="text/javascript">
				jQuery(document).ready(function($){
					$('#popup-reminder-form').bind('submit',function(){
						ls.user.reminder('popup-reminder-form');
						return false;
					});
					$('#popup-reminder-form-submit').attr('disabled',false);
				});
			</script>
			<form action="{router page='login'}reminder/" method="POST" id="popup-reminder-form">
				<p><label for="popup-reminder-mail">{$aLang.password_reminder_email}</label>
				<input type="text" name="mail" id="popup-reminder-mail" class="input-text input-width-300" />
				<small class="validate-error-hide validate-error-reminder"></small></p>

				<button type="submit" name="submit_reminder" class="button button-primary" id="popup-reminder-form-submit" disabled="disabled">{$aLang.password_reminder_submit}</button>
			</form>
		</div>
	</div>
{/block}