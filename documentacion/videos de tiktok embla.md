# Implementación de Sección TikTok (Método Embed/Ebla)

Esta guía detalla el proceso técnico realizado para permitir la renderización de videos de TikTok dentro de la tienda Tiendanube, superando la limitación nativa que solo permite URLs de YouTube y Vimeo.

## 1. El Problema Técnico
Nativamente, el componente de video de la plataforma intenta parsear la URL buscando patrones como `watch?v=` o `youtu.be`. Al ingresar una URL de TikTok, el sistema no logra extraer un ID válido y el reproductor de la API de YouTube falla al intentar cargar contenido ajeno a su plataforma.

## 2. La Solución: Método Embed (Ebla)
Para solucionar esto sin depender de APIs externas limitadas, se creó una sección personalizada que utiliza el código de inserción (**Embed**) oficial de TikTok. Este método utiliza una etiqueta `<blockquote>` con atributos de datos y un script asíncrono que transforma dicha etiqueta en un reproductor funcional.

## 3. Pasos de la Implementación

### A. Definición de Variables de Configuración (`config/settings.txt`)
Se registraron los campos necesarios para que el usuario pueda gestionar la sección desde el administrador de la tienda.

```text
	collapse
		title = TikTok
		backto = home_order_position
	i18n_input
		name = tiktok_title
		description = Título (opcional)
	i18n_input
		name = tiktok_url
		description = URL del video de TikTok
	description
		description = Ej: https://www.tiktok.com/@usuario/video/1234567890
```

También se añadió la opción `tiktok` al listado de secciones disponibles en el orden de la página de inicio:
```text
		sections
			...
			tiktok = TikTok
```

### B. Creación del Snippet (`snipplets/home/home-tiktok.tpl`)
Este archivo contiene la lógica para procesar la URL y renderizar el código necesario. 

**Lógica de extracción de ID:**
Se utiliza el filtro `split` de Twig para obtener el ID numérico del video a partir de la URL del usuario, lo cual es necesario para el atributo `data-video-id`.

```twig
{% set tiktok_url = settings.tiktok_url %}
{% if tiktok_url %}
    {% set tiktok_id = tiktok_url|split('/video/')|last|split('?')|first|split('/')|first %}

    <section class="section-tiktok-home py-5" data-store="home-tiktok">
        <div class="container text-center">
            {% if settings.tiktok_title %}
                <h2 class="h1-huge mb-4">{{ settings.tiktok_title }}</h2>
            {% endif %}
            <div class="d-flex justify-content-center">
                <blockquote class="tiktok-embed" cite="{{ tiktok_url }}" data-video-id="{{ tiktok_id }}">
                    <section>
                        <a target="_blank" href="{{ tiktok_url }}">TikTok Video</a>
                    </section> 
                </blockquote>
            </div>
            <script async src="https://www.tiktok.com/embed.js"></script>
        </div>
    </section>
{% endif %}
```

### C. Integración en el Sistema de Secciones (`snipplets/home/home-section-switch.tpl`)
Para que la sección aparezca dinámicamente según el orden elegido por el cliente, se añadió el caso al selector oficial de la tienda:

```twig
{% elseif section_select == 'tiktok' %}
	{% include 'snipplets/home/home-tiktok.tpl' %}
```

### D. Lógica de Placeholders (`templates/home.tpl`)
Se añadió la variable `has_tiktok` para asegurar que el sistema de "tienda vacía" reconozca que hay contenido visual cuando esta sección está activa.

```twig
{% set has_tiktok = settings.tiktok_url %}
...
{% set show_help = not (... or has_tiktok) and not has_products %}
```

## 4. Cómo Replicar / Usar
1.  **En el Administrador:** Ir a `Personalizar diseño` > `Página de inicio` > `TikTok`.
2.  **Pegar URL:** Introducir la URL completa del video.
3.  **Ordenar:** En `Orden de secciones`, mover la opción "TikTok" a la posición deseada.

> [!TIP]
> Este método es "Ebla-ready" (Embed Ready), lo que significa que respeta los tiempos de carga de la página al usar un script asíncrono, evitando que el sitio se vuelva lento debido a scripts externos.
