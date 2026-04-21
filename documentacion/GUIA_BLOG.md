# Guía de Plantillas de Blog en Tiendanube

Este documento explica cómo funcionan, cómo editar y cómo acceder a la información del blog en tu proyecto, específicamente en los archivos `templates/blog.tpl` y `templates/blog-post.tpl`.

## 1. El Listado del Blog (`templates/blog.tpl`)

Este archivo es el responsable de mostrar la página principal de tu blog, que es esencialmente un feed o listado de todos tus artículos disponibles.

### ¿Cómo funciona actualmente?
Al abrir tu archivo `blog.tpl`, notarás que itera sobre los artículos (posts) disponibles mediante un ciclo `for`:

```twig
{% for post in blog.posts %}
   {# Contenido de la tarjeta del artículo #}
{% endfor %}
```

Dentro de este loop, actualmente usas el atajo estandarizado que provee Tiendanube: `{{ component('blog/blog-post-item', { ... }) }}`. Esto facilita su mantenimiento pero en ocasiones oculta el marcado HTML.

### ¿Cómo personalizar el diseño o editar la información de cada artículo desde cero?
Si deseas crear tu propio diseño para que el blog luzca diferente y no usar el componente automático, puedes reemplazar ese bloque `{{ component(...) }}` por tu propio código HTML, llamando directamente a las propiedades.

Por ejemplo, tu ciclo `for` modificado se vería así:

```twig
<div class="row">
    {% for post in blog.posts %}
        <div class="col-md-4 mb-4">
            <article class="mi-post-personalizado">
                {# 1. Imagen del post #}
                {% if post.image %}
                    <div class="imagen-contenedor mb-2">
                        <a href="{{ post.url }}">
                            <img src="{{ post.image | static_url }}" alt="{{ post.title }}" class="img-fluid fade-in">
                        </a>
                    </div>
                {% endif %}

                {# 2. Fecha del post y autor (opcional) #}
                <div class="post-date text-muted font-small mb-1">
                    {{ post.date | date("d/m/Y") }}
                </div>

                {# 3. Título del post #}
                <h2 class="item-name mb-2 text-center">
                    <a href="{{ post.url }}">{{ post.title }}</a>
                </h2>

                {# 4. Resumen (Descripción Corta) #}
                <p class="post-summary mb-3 font-small text-center">
                    {{ post.summary }}
                </p>

                {# 5. Botón de Leer Más #}
                <div class="text-center">
                     <a href="{{ post.url }}" class="btn-link btn-link-primary">
                         Leer más
                     </a>
                </div>
            </article>
        </div>
    {% endfor %}
</div>
```

---

## 2. El Detalle del Artículo (`templates/blog-post.tpl`)

Este archivo es el responsable de mostrar la página de lectura completa de un artículo cuando un usuario le da clic en el listado. 

### ¿Cómo funciona actualmente?
En tu `blog-post.tpl` accedes directamente a la variable global llamada `post`. Aquí ocurre lo similar que en el caso anterior; se llama automáticamente al componente de Tiendanube `{{ component('blog/blog-post-content', { ... }) }}`.

### ¿Cómo personalizar y construir tu propia estructura para el post?
Puedes eliminar la función de componente y estructurar la noticia tú mismo según tus preferencias de diseño y clases (por ejemplo para Bootstrap o Tailwind):

```twig
<div class="container container-narrow">
    {# Título General #}
    {% embed "snipplets/page-header.tpl" with { breadcrumbs: true, page_header_title_class: 'mb-0' } %}
        {% block page_header_text %}{{ post.title }}{% endblock page_header_text %}
    {% endembed %}

    <div class="blog-post-page pb-5">
        {# Fecha y metadatos #}
        <div class="font-small text-muted mb-2 text-center">
            Publicado el {{ post.date | date("d/m/Y") }}
        </div>

        {# Imagen Principal del Artículo #}
        {% if post.image %}
            <div class="mb-4 pb-2">
                <img src="{{ post.image | static_url }}" alt="{{ post.title }}" class="img-fluid fade-in w-100">
            </div>
        {% endif %}

        {# Contenido o Cuerpo del Post #}
        <div class="post-content mb-2" style="font-size: 1.1rem; line-height: 1.8;">
            {# post.content imprimirá todo el texto con negritas, títulos y enlaces 
               que configuraste desde el administrador de Tiendanube. #}
            {{ post.content }}
        </div>
    </div>
</div>
```

---

## 3. Todas Variables Disponibles para llamar la información

Siempre que tengas acceso al objeto `post` (ya sea por tu ciclo `for` en `blog.tpl` o de forma directa en `blog-post.tpl`), puedes mandar llamar a esta información usando las dobles llaves `{{ ... }}`:

- **Título del blog**: `{{ post.title }}`
- **Enlace/URL**: `{{ post.url }}` (Usado principalmente dentro del atributo `href` de una etiqueta `<a>`).
- **Resumen / Descripción**: `{{ post.summary }}`. Este es el extracto de texto que pones antes del "cortador" en el formato del panel de tienda.
- **Contenido Completo**: `{{ post.content }}`. Esto trae todo tu HTML (negritas, subtítulos) ingresado desde el panel para la página estática del post.
- **Imagen Principal**: `{{ post.image }}`. Solo trae la información cruda de la imagen. **IMPORTANTE**: La manera correcta de invocar la imagen es combinándola con filtros de Twig como `{{ post.image | static_url }}` o `{{ post.image | resize('800x800') }}` si deseas optimizarla.
- **Fecha de publicación**: `{{ post.date }}`. Se recomienda aplicarle un formateador, como por ejemplo `{{ post.date | date("d \de F \de Y") }}` (para "10 de Abril de 2026"). 

> [!TIP]
> Recuerda siempre comprobar si la imagen existe antes de mostrarla para evitar un espacio vacío o imagen rota en tu tienda: `{% if post.image %} <img src="{{ post.image | static_url }}"> {% endif %}`.

## 4. El Objeto `blog` (Solo en `blog.tpl`)

Aparte del loop de `blog.posts`, el archivo `blog.tpl` permite interactuar con el comportamiento global de la colección del blog mediante:

- `blog.title`: Te da el título general configurado si lo hubiera.
- `blog.url`: Te retorna la URL base de todo tu blog.
- `blog.pages`: Un controlador para armar la páginación (por si tienes 50 blogs, mostrar páginas abajo). Esto ya está incluido en tus archivos actuales usando `{% include 'snipplets/grid/pagination.tpl' with {'pages': blog.pages} %}`.
