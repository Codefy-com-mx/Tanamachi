{% if sections.featured.products %}
	{% if settings.main_product_type == 'random' %}
		{% set product_type = sections.featured.products | shuffle | take(1) %}
	{% else %}
		{% set product_type = sections.featured.products | take(1) %}
	{% endif %}

	{% for product in product_type %}
		<section id="single-product" class="js-product-container section-main-product-home" data-variants="{{product.variants_object | json_encode }}" data-store="home-product-main">
			<div class="container-fluid px-0">
				<div class="row m-0 no-gutters align-items-center">
					<div class="col-md-5 col-lg-4 order-1 order-md-1 mb-4 mb-md-0 px-4 px-md-4" data-store="product-info-{{ product.id }}">
						<div class="main-product-info-wrapper" style="max-width: 467px; width: 100%; margin: 0;">
							{# Product Name #}
							<h2 class="section-main-product-title h3 mb-4 text-center text-md-left">{{ product.name }}</h2>

							{% if product.description is not empty %}
								<div class="mb-4">
									{# Product description #}
									<div class="js-product-description product-description user-content text-justify text-md-left font-small">
										{{ product.description }}
									</div>
									<div class="js-view-description d-none" style="display: none;">
										<div class="btn-link font-small mt-1">
											{% if settings.positive_color_background %}
												{% set view_description_icon_class = 'icon-inline icon-lg svg-icon-invert ml-1' %}
											 {% else %}
												{% set view_description_icon_class = 'icon-inline icon-lg svg-icon-text ml-1' %}
											{% endif %}
											<span class="js-view-more">
												{{ "Ver más" | translate }}
											</span>
											<span class="js-view-less" style="display: none;">
												{{ "Ver menos" | translate }}
											</span>
										</div>
									</div>
								</div>
							{% endif %}

							<div class="text-center text-md-left font-weight-bold mb-3" style="font-size: 0.8rem; letter-spacing: 0.5px;">/EXCL. SHIPPING.</div>

							{% include 'snipplets/product/product-form.tpl' with { home_main_product: true } %}
						</div>
					</div>

					<div class="col-md-7 col-lg-8 order-2 order-md-2 pb-3 pr-md-0 mb-4 mb-md-0 js-main-product-image-col">
						{% include 'snipplets/product/product-image.tpl' with { home_main_product: true } %}
					</div>
				</div>
			</div>
		</section>
	{% endfor %}
{% endif %}
