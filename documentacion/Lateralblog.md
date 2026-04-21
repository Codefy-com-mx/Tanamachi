# Implementación de Sidebar Dinámico para Blog (Tiendanube)

Esta guía documenta la solución implementada para mostrar un listado de "Noticias Recientes" en la página de un post individual, superando la limitación nativa donde Tiendanube no entrega el objeto `blog.posts` fuera del listado general.

## 1. El Problema Técnico
Nativamente, Tiendanube restringe el acceso a la colección completa de artículos cuando un usuario está leyendo un artículo específico (`blog-post.tpl`). Esto impide usar ciclos `for` tradicionales de Twig para mostrar "Posts relacionados" o "Recientes" de forma directa mediante servidor.

## 2. La Solución: Carga Dinámica (AJAX)
Para solucionar esto sin depender de las restricciones del servidor, implementamos un script de JavaScript que:
1. Visita la página `/blog` de forma asíncrona (AJAX).
2. Escanea el HTML recibido en busca de artículos (clase `.item`).
3. Extrae dinámicamente títulos, imágenes (soporta Lazy Load y Srcset) y enlaces.
4. Los renderiza en un contenedor dentro del Sidebar.

---

## 3. Estructura de Archivos

### A. El Snippet (`snipplets/blog/blog-sidebar.tpl`)
Este archivo contiene el marcado del sidebar y el script de extracción.

```twig
<aside class="blog-sidebar">
    <h3 class="h6-accent mb-4">{{ "Noticias recientes" | translate }}</h3>
    
    <div id="js-recent-posts-container" class="row">
        <div class="col-12">
            <p class="font-small text-muted italic small">Cargando publicaciones...</p>
        </div>
    </div>

    <div class="mt-3 pt-3 border-top">
        <a href="/blog" class="btn-link btn-link-primary font-small">
            {{ "Ver todo el blog" | translate }}
        </a>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        fetch('/blog')
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                const posts = doc.querySelectorAll('.item'); 
                const container = document.getElementById('js-recent-posts-container');
                
                if (posts.length > 0) {
                    container.innerHTML = '';
                    let count = 0;
                    const currentUrl = window.location.pathname;

                    posts.forEach(post => {
                        const titleEl = post.querySelector('.item-name');
                        const linkEl = post.querySelector('a');
                        const imgTag = post.querySelector('img');

                        if (titleEl && linkEl && count < 4) {
                            const title = titleEl.innerText;
                            const link = linkEl.href;
                            let imgSrc = '';

                            if (imgTag) {
                                const dataSrcset = imgTag.getAttribute('data-srcset') || imgTag.getAttribute('srcset');
                                if (dataSrcset) { imgSrc = dataSrcset.split(' ')[0]; }
                                if (!imgSrc) { imgSrc = imgTag.getAttribute('data-src') || imgTag.src; }
                            }

                            if (!link.includes(currentUrl)) {
                                const postHtml = `
                                    <div class="col-12 mb-4">
                                        <a href="${link}" class="row no-gutters align-items-center" style="text-decoration: none !important;">
                                            <div class="col-4 pr-0">
                                                <div style="width: 100%; padding-bottom: 100%; position: relative; border-radius: 4px; overflow: hidden; background: #eee;">
                                                    <img src="${imgSrc}" style="position: absolute; width: 100%; height: 100%; object-fit: cover; border: 0; display: block;">
                                                </div>
                                            </div>
                                            <div class="col-8 pl-3">
                                                <h4 style="font-size: 13px; font-weight: 600; line-height: 1.3; color: #000; margin: 0; text-align: left; text-transform:none;">${title}</h4>
                                            </div>
                                        </a>
                                    </div>`;
                                container.innerHTML += postHtml;
                                count++;
                            }
                        }
                    });
                }
            });
    });
</script>
```

### B. El Cambio de Layout (`templates/blog-post.tpl`)
Para activar el sidebar, se debe reemplazar el contenedor simple por un Grid de Bootstrap:

```twig
<div class="container">
    <div class="row pt-4 pb-5">
        {# Sidebar a la izquierda #}
        <aside class="col-md-3 order-md-1 order-2">
            {% include "snipplets/blog/blog-sidebar.tpl" %}
        </aside>

        {# Contenido a la derecha #}
        <div class="col-md-9 order-md-2 order-1">
             {# Componente del Post aquí #}
        </div>
    </div>
</div>
```

---

## 4. Estilos CSS
Ubicación recomendada: `static/css/style-new-section.scss`

```css
.blog-sidebar {
  background: #fff;
  padding-right: 20px;
}
.blog-sidebar .h6-accent {
  font-family: var(--body-font);
  text-transform: uppercase;
  letter-spacing: 2px;
  font-size: 12px;
  border-bottom: 2px solid #000;
  display: inline-block;
  padding-bottom: 5px;
}
```
