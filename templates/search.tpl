{% if settings.pagination == 'infinite' %}
	{% paginate by 12 %}
{% else %}
	{% paginate by 24 %}
{% endif %}

<div class="container mt-4">
	<div class="d-flex flex-wrap align-items-baseline mb-2">
		<div class="mr-3">
			{% embed "snipplets/page-header.tpl" with { show_breadcrumbs: false, container: false, padding: false, page_header_text_alignment: 'text-left', page_header_title_class: 'text-35px mb-0 font-weight-bold' } %}
				{% block page_header_text %}
					{% if products %}
						{{ 'Productos' | translate }}
					{% else %}
						{{ "No encontramos nada para" | translate }}<span class="ml-2">"{{ query }}"</span>
					{% endif %}
				{% endblock page_header_text %}
			{% endembed %}
		</div>
		<div class="mt-2">
			{% if products %}
				<a href="#" class="js-modal-open btn-link text-35px font-weight-bold" data-toggle="#nav-filters" data-component="filter-button">
					{{ "Filtrar" | translate }}
				</a>
			{% endif %}
		</div>
	</div>
	{% if products and query %}
		<h2 class="h5 pb-2 font-weight-normal text-left mb-4">
			{{ "Mostrando los resultados para" | translate }}<span class="ml-2 font-weight-bold">"{{ query }}"</span>
		</h2>		
	{% endif %}
</div>

{% include 'snipplets/grid/filters-modals.tpl' with {show_filter_button: false} %}
<section class="js-category-controls-prev category-controls-sticky-detector"></section>

<section class="category-body overflow-none">
	<div class="container-fluid px-0 {% if search_filter and products %}mt-4{% endif %} mb-5">
		{% include 'snipplets/grid/product-list.tpl' %}
	</div>
</section>