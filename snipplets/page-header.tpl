{# /*============================================================================
  #Page header
==============================================================================*/

#Properties

#Title

#Breadcrumbs

#}

{% set padding = padding ?? true %}
{% set container = container ?? true %}
{% set show_breadcrumbs = show_breadcrumbs ?? true %}
{% set page_header_text_alignment = page_header_text_alignment ?? 'text-center' %}

{% if container %}
	<div class="container">
{% endif %}
		<section class="page-header {% if padding %}py-4{% endif %} {{ page_header_text_alignment }} {{ page_header_class }}" data-store="page-title">
			{% if show_breadcrumbs %}
				{% include 'snipplets/breadcrumbs.tpl' %}
			{% endif %}
			<h1 class="{% if template == 'product' %}h2{% else %}h4{% endif %} {{ page_header_title_class }}" {% if template == "product" %}data-store="product-name-{{ product.id }}"{% endif %}>{% block page_header_text %}{% endblock %}</h1>
		</section>
{% if container %}
	</div>
{% endif %}
