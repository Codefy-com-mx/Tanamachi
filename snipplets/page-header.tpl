{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs

#}

{% set padding = padding ?? true %}
{% set container = container ?? true %}

{% if container %}
	<div class="container">
{% endif %}
		<section class="page-header {% if padding %}py-4{% endif %} text-left {{ page_header_class }}" data-store="page-title">
			{% if not hide_breadcrumbs %}
				{% include 'snipplets/breadcrumbs.tpl' %}
			{% endif %}
			<div class="d-flex align-items-center flex-wrap">
				<h1 class="h1 mb-0 mr-3 {{ page_header_title_class }}" {% if template == "product" %}data-store="product-name-{{ product.id }}"{% endif %}>{% block page_header_text %}{% endblock %}</h1>
				<div class="page-header-aside mt-2 mt-md-0">
					{% block page_header_aside %}{% endblock %}
				</div>
			</div>
		</section>
{% if container %}
	</div>
{% endif %}
