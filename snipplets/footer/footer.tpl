{% set has_social_network = store.facebook or store.twitter or store.pinterest or store.instagram or store.tiktok or store.youtube %}
{% set has_footer_contact_info = (store.whatsapp or store.phone or store.email or store.address or store.blog) and settings.footer_contact_show %}          

{% set has_footer_logo = "footer_logo.jpg" | has_custom_image %}
{% set has_footer_menu = settings.footer_menu and settings.footer_menu_show %}
{% set has_payment_logos = settings.payments %}
{% set has_shipping_logos = settings.shipping %}
{% set has_shipping_payment_logos = has_payment_logos or has_shipping_logos %}
{% set has_languages = languages | length > 1 and settings.languages_footer %}

{% set has_seal_logos = store.afip or ebit or settings.custom_seal_code or ("seal_img.jpg" | has_custom_image) %}
{% set show_help = not has_products and not has_social_network %}
<footer class="js-footer js-hide-footer-while-scrolling display-when-content-ready overflow-none {% if settings.footer_colors %}footer-colors{% endif %} py-5" data-store="footer">
	<div class="container py-lg-4">
		<div class="row justify-content-center align-items-start">
			
			{# Column 1: Brand Info #}
			<div class="col-md-2 mb-4 mb-md-0 text-left js-footer-accordion">
				<h4 class="h6 mb-3 js-footer-accordion-toggle position-relative text-uppercase" style="font-family: var(--footer-font-col1); font-size: var(--footer-size-col1); cursor: pointer;">
					{% if settings.footer_brand_info_title %}
						{{ settings.footer_brand_info_title }}
					{% else %}
						&nbsp;
					{% endif %}
					<span class="d-md-none position-absolute footer-accordion-icon" style="right: 0px;"></span>
				</h4>
				<div class="footer-accordion-content">
					<div class="font-small opacity-50 line-height-small">
						{{ settings.footer_brand_info | nl2br }}
					</div>
				</div>
			</div>

			{# Column 2: Menu 1 #}
			{% if settings.footer_menu_show and settings.footer_menu %}
				<div class="col-md-2 mb-4 mb-md-0 text-left js-footer-accordion">
					<h4 class="h6 mb-3 js-footer-accordion-toggle position-relative text-uppercase" style="font-family: var(--footer-font-col2); font-size: var(--footer-size-col2); cursor: pointer;">
						{% if settings.footer_menu_title %}
							{{ settings.footer_menu_title }}
						{% else %}
							&nbsp;
						{% endif %}
						<span class="d-md-none position-absolute footer-accordion-icon" style="right: 0px;"></span>
					</h4>
					<div class="footer-accordion-content">
						<ul class="list-unstyled font-small opacity-50">
							{% for item in menus[settings.footer_menu] %}
								<li class="mb-2">
									<a href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %} class="btn-link p-0 text-decoration-underline">{{ item.name }}</a>
								</li>
							{% endfor %}
							{% if settings.footer_menu_secondary %}
								{% for item in menus[settings.footer_menu_secondary] %}
									<li class="mb-2 d-block d-md-none">
										<a href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %} class="btn-link p-0 text-decoration-underline">{{ item.name }}</a>
									</li>
								{% endfor %}
							{% endif %}
						</ul>
					</div>
				</div>
			{% endif %}

			{# Column 3: Menu 2 #}
			{% if settings.footer_menu_show and settings.footer_menu_secondary %}
				<div class="col-md-2 mb-4 mb-md-0 text-left js-footer-accordion d-none d-md-block">
					<h4 class="h6 mb-3 js-footer-accordion-toggle position-relative text-uppercase" style="font-family: var(--footer-font-col3); font-size: var(--footer-size-col3); cursor: pointer;">
						{% if settings.footer_menu_secondary_title %}
							{{ settings.footer_menu_secondary_title }}
						{% else %}
							&nbsp;
						{% endif %}
						<span class="d-md-none position-absolute footer-accordion-icon" style="right: 0px;"></span>
					</h4>
					<div class="footer-accordion-content">
						<ul class="list-unstyled font-small opacity-50">
							{% for item in menus[settings.footer_menu_secondary] %}
								<li class="mb-2">
									<a href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %} class="btn-link p-0 text-decoration-underline">{{ item.name }}</a>
								</li>
							{% endfor %}
						</ul>
					</div>
				</div>
			{% endif %}

			{# Column 4: Menu 3 #}
			{% if settings.footer_menu_show and settings.footer_menu_tertiary %}
				<div class="col-md-2 mb-4 mb-md-0 text-left js-footer-accordion">
					<h4 class="h6 mb-3 js-footer-accordion-toggle position-relative text-uppercase" style="font-family: var(--footer-font-col4); font-size: var(--footer-size-col4); cursor: pointer;">
						{% if settings.footer_menu_tertiary_title %}
							{{ settings.footer_menu_tertiary_title }}
						{% else %}
							&nbsp;
						{% endif %}
						<span class="d-md-none position-absolute footer-accordion-icon" style="right: 0px;"></span>
					</h4>
					<div class="footer-accordion-content">
						<ul class="list-unstyled font-small opacity-50">
							{% for item in menus[settings.footer_menu_tertiary] %}
								<li class="mb-2">
									<a href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %} class="btn-link p-0 text-decoration-underline">{{ item.name }}</a>
								</li>
							{% endfor %}
						</ul>
					</div>
				</div>
			{% endif %}

			{# Column 5: Universe Info #}
			<div class="col-md-2 mb-4 mb-md-0 text-left">
				<h4 class="h6 mb-3 font-weight-bold opacity-50 text-uppercase" style="font-family: var(--footer-font-col5); font-size: var(--footer-size-col5);">
					{% if settings.footer_universe_title %}
						{{ settings.footer_universe_title }}
					{% else %}
						&nbsp;
					{% endif %}
				</h4>
				<div class="font-small opacity-50 line-height-small d-block mt-3">
					{{ settings.footer_universe_info | nl2br }}
				</div>
			</div>

			{# Column 6: Logo #}
			<div class="col-md-2 text-center text-md-right">
				{% if has_footer_logo %}
					<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ 'footer_logo.jpg' | static_url('large') }}" alt="{{ store.name }}" title="{{ store.name }}" class="footer-logo-img-large lazyload img-fluid">
				{% endif %}
			</div>
		</div>

		<div class="row mt-5 pt-5 border-top-0">
			<div class="col-12 font-smallest opacity-50">
				<div class="row">
					<div class="col-md-12 text-center text-md-left">
						<div class="row align-items-center">
							<div class="col-md-auto col-12 order-md-1 order-3 mt-3 mt-md-0">
								<div class="font-smallest opacity-50">
									{{ "Copyright {1} - {2}. Todos los derechos reservados." | translate( (store.business_name ? store.business_name : store.name) ~ (store.business_id ? ' - ' ~ store.business_id : ''), "now" | date('Y') ) }}
								</div>
							</div>
							<div class="col-md-auto col-12 order-md-2 order-1 mb-2 mb-md-0">
								<div class="d-inline-block align-middle">
									{{ new_powered_by_link }}
								</div>
								<div class="d-none d-md-inline-block mx-2 opacity-50">|</div>
							</div>
							<div class="col-md-auto col-12 order-md-3 order-2">
								<div class="d-inline-block align-middle font-smallest opacity-50">
									Desarrollado por <a href="https://www.codefy.com.mx" target="_blank" class="btn-link font-weight-bold opacity-100" style="color: inherit; opacity: 1 !important;">Codefy</a>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-6 text-right">
						{{ component('claim-info', {
								container_classes: "d-inline-block",
								divider_classes: "mx-1 d-none d-md-inline-block",
								text_classes: {text_consumer_defense: 'd-inline-block mr-2'},
								link_classes: {
									link_consumer_defense: "btn-link font-smallest",
									link_order_cancellation: "btn-link font-smallest d-inline-block ml-3",
								},
							}) 
						}}
					</div>
				</div>
			</div>
		</div>
	</div>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var accordions = document.querySelectorAll('.js-footer-accordion');
    accordions.forEach(function(acc) {
        var toggle = acc.querySelector('.js-footer-accordion-toggle');
        if (toggle) {
            toggle.addEventListener('click', function() {
                if (window.innerWidth < 768) {
                    var isCurrentlyOpen = acc.classList.contains('is-open');
                    
                    // Cerrar todos
                    accordions.forEach(function(otherAcc) {
                        otherAcc.classList.remove('is-open');
                    });

                    // Si no estaba abierto, lo abrimos
                    if (!isCurrentlyOpen) {
                        acc.classList.add('is-open');
                    }
                }
            });
        }
    });
});
</script>