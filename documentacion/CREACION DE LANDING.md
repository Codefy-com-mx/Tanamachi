## 🚀 Creación de Landing Corporativos (Codefy)

Esta guía documenta todo el proceso para habilitar una **landing independiente** en Tiendanube dedicada al segmento **Corporativos** (URL prevista: `corporativo`). Replica la lógica usada en “Compra por Pasos” y “Emprende”, asegurando que la página se renderice con un template propio sin mostrar el header institucional.

---

### 1. Configuración en el personalizador (`config/settings.txt`)

1. Ubicar la sección **“Corporativos (Codefy)”** o crearla si no existe.
2. Agregar un bloque `collapse` llamado “Página independiente Corporativos”.
3. Dentro del bloque incluir:
   - Campo `text` **`name = corporativos_page_url`** (sin `/`).
   - Campo `text` **`name = corporativos_page_title`** (opcional).
   - Subtítulo recordando que se debe crear la página en Contenido > Páginas con la misma URL.
4. Mantener toda la configuración visual existente (imágenes, textos, colores) para reutilizarla dentro del nuevo template.

> **Tip:** Usa el prefijo `corporativos_...` para mantener consistencia con otras secciones del tema.

---

### 2. Valores por defecto (`config/defaults.txt`)

Agregar los valores:
```
corporativos_page_url = corporativo
corporativos_page_title = Corporativos
```
Así, en una instalación limpia ya queda definida la ruta `/corporativo`.

---

### 3. Detección de la página (`templates/page.tpl`)

1. Crear una variable booleana:
   ```twig
   {% set is_corporativos_page = page.handle == settings.corporativos_page_url and settings.corporativos_page_url %}
   ```
2. Evitar renderizar el header cuando sea Corporativos:
   ```twig
   {% if not is_compra_pasos_page and not is_emprende_page and not is_corporativos_page %}
       ... header ...
   {% endif %}
   ```
3. Incluir el template específico:
   ```twig
   {% elseif is_corporativos_page %}
       {% include "snipplets/page-corporativos.tpl" %}
   ```

---

### 4. Template dedicado (`snipplets/page-corporativos.tpl`)

El template puede reutilizar secciones existentes del home. Ejemplo completo implementado:

#### 4.1. Estructura del template

```twig
{# Banner Custom (Codefy) - Sección del home #}
{% if settings.side_banner_show %}
	{% include 'snipplets/home/home-side-banner.tpl' %}
{% endif %}

{# Marcas - Sección del home #}
{% if settings.brands and settings.brands is not empty %}
	{% include 'snipplets/home/home-brands.tpl' %}
{% endif %}

{# Regalos Empresariales (Codefy) - Sección del home #}
{% include 'snipplets/home/home-regalos-empresariales.tpl' %}

{# Banners promocionales - Sección del home #}
{% if settings.banner_promotional and settings.banner_promotional is not empty %}
	<section class="section-banners-home position-relative" data-store="home-banner-promotional">
		{% include 'snipplets/home/home-banners.tpl' with {'has_banner_promotional': true} %}
	</section>
{% endif %}
```

#### 4.2. Secciones disponibles del home

Puedes incluir cualquier sección del home usando `{% include %}`:

- **Banner Custom (Codefy)**: `snipplets/home/home-side-banner.tpl`
  - Condición: `settings.side_banner_show`
  
- **Marcas**: `snipplets/home/home-brands.tpl`
  - Condición: `settings.brands and settings.brands is not empty`
  
- **Regalos Empresariales (Codefy)**: `snipplets/home/home-regalos-empresariales.tpl`
  - Se muestra si `settings.regalos_empresariales_show` está activado (el template maneja su propia condición)
  
- **Banners Promocionales**: `snipplets/home/home-banners.tpl` con `{'has_banner_promotional': true}`
  - Condición: `settings.banner_promotional and settings.banner_promotional is not empty`
  - Requiere wrapper: `<section class="section-banners-home position-relative" data-store="home-banner-promotional">`

#### 4.3. JavaScript para inicializar carruseles

**IMPORTANTE**: Los carruseles del home solo se inicializan cuando `template == 'home'` en `store.js.tpl`. Para que funcionen en páginas independientes, debes agregar JavaScript que los inicialice.

Ejemplo completo para Corporativos:

```javascript
<script>
(function() {
    'use strict';
    
    function initCorporativosCarousels() {
        // Verificar que createSwiper esté disponible
        if (typeof createSwiper === 'undefined') {
            setTimeout(initCorporativosCarousels, 100);
            return;
        }
        
        var itemSwiperSpaceBetween = 30;
        
        // Función para ocultar controles cuando no hay más slides
        var hideSwiperControls = function(elemPrev, elemNext) {
            if (typeof jQueryNuvem !== 'undefined') {
                if ((jQueryNuvem(elemPrev).hasClass("swiper-button-disabled") && jQueryNuvem(elemNext).hasClass("swiper-button-disabled"))) {
                    jQueryNuvem(elemPrev).remove();
                    jQueryNuvem(elemNext).remove();
                }
            }
        };
        
        {# Inicializar carrusel de Marcas #}
        {% if settings.brands and settings.brands is not empty and settings.brands_format == 'slider' %}
        var brandsSwiper = document.querySelector('.js-swiper-brands');
        if (brandsSwiper && !brandsSwiper.swiper) {
            createSwiper('.js-swiper-brands', {
                lazy: true,
                watchOverflow: true,
                centerInsufficientSlides: true,
                threshold: 5,
                spaceBetween: itemSwiperSpaceBetween,
                slidesPerView: 3,
                navigation: {
                    nextEl: '.js-swiper-brands-next',
                    prevEl: '.js-swiper-brands-prev',
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-brands-prev", ".js-swiper-brands-next");
                    },
                    {% if settings.brands | length > 3 and settings.brands | length < 6 %}
                    beforeInit: function () {
                        if (window.innerWidth > 768 && typeof jQueryNuvem !== 'undefined') {
                            jQueryNuvem(".js-swiper-brands-wrapper").addClass("justify-content-center");
                        }
                    },
                    {% endif %}
                },
                breakpoints: {
                    768: {
                        slidesPerView: 6,
                    }
                }
            });
        }
        {% endif %}
        
        {# Inicializar carrusel de Banners Promocionales #}
        {% if settings.banner_promotional_slider and settings.banner_promotional and settings.banner_promotional is not empty %}
        var bannerPromotionalSwiper = document.querySelector('.js-swiper-banners-promotional');
        if (bannerPromotionalSwiper && !bannerPromotionalSwiper.swiper) {
            {% set banner_promotional_columns_desktop = settings.banner_promotional_columns_desktop %}
            var bannersPromotionalPerViewDesktopVal = {% if banner_promotional_columns_desktop == 4 %}4{% elseif banner_promotional_columns_desktop == 3 %}3{% elseif banner_promotional_columns_desktop == 2 %}2{% else %}1{% endif %};
            var bannersPromotionalPerViewMobileVal = 1;
            var bannersPromotionalSpaceBetween = {% if settings.banner_promotional_without_margins %}0{% else %}itemSwiperSpaceBetween{% endif %};
            
            createSwiper('.js-swiper-banners-promotional', {
                lazy: true,
                watchOverflow: true,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: bannersPromotionalSpaceBetween,
                centerInsufficientSlides: true,
                navigation: {
                    nextEl: '.js-swiper-banners-promotional-next',
                    prevEl: '.js-swiper-banners-promotional-prev',
                },
                pagination: {
                    el: '.js-swiper-banners-promotional-pagination',
                    type: 'fraction',
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-banners-promotional-prev", ".js-swiper-banners-promotional-next");
                    },
                },
                slidesPerView: bannersPromotionalPerViewMobileVal,
                breakpoints: {
                    768: {
                        slidesPerView: bannersPromotionalPerViewDesktopVal,
                    }
                }
            });
        }
        
        {# Inicializar carrusel móvil de Banners Promocionales #}
        {% if settings.toggle_banner_promotional_mobile and settings.banner_promotional_mobile and settings.banner_promotional_mobile is not empty %}
        var bannerPromotionalMobileSwiper = document.querySelector('.js-swiper-banners-promotional-mobile');
        if (bannerPromotionalMobileSwiper && !bannerPromotionalMobileSwiper.swiper) {
            createSwiper('.js-swiper-banners-promotional-mobile', {
                lazy: true,
                watchOverflow: true,
                threshold: 5,
                watchSlideProgress: true,
                watchSlidesVisibility: true,
                slideVisibleClass: 'js-swiper-slide-visible',
                spaceBetween: bannersPromotionalSpaceBetween,
                centerInsufficientSlides: true,
                navigation: {
                    nextEl: '.js-swiper-banners-promotional-mobile-next',
                    prevEl: '.js-swiper-banners-promotional-mobile-prev',
                },
                pagination: {
                    el: '.js-swiper-banners-promotional-mobile-pagination',
                    type: 'fraction',
                },
                on: {
                    afterInit: function () {
                        hideSwiperControls(".js-swiper-banners-promotional-mobile-prev", ".js-swiper-banners-promotional-mobile-next");
                    },
                },
                slidesPerView: bannersPromotionalPerViewMobileVal,
                breakpoints: {
                    768: {
                        slidesPerView: bannersPromotionalPerViewDesktopVal,
                    }
                }
            });
        }
        {% endif %}
        {% endif %}
    }
    
    // Ejecutar cuando el DOM esté listo
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initCorporativosCarousels);
    } else {
        setTimeout(initCorporativosCarousels, 100);
    }
})();
</script>
```

**Puntos clave del JavaScript**:
- Verifica que `createSwiper` esté disponible antes de inicializar
- Evita duplicar inicializaciones verificando `!brandsSwiper.swiper`
- Usa las mismas configuraciones que el home para mantener consistencia
- Maneja versiones desktop y móvil por separado
- Se ejecuta cuando el DOM está listo

#### 4.4. Orden de secciones en Corporativos

1. **Banner Custom (Codefy)** - Si `settings.side_banner_show` está activado
2. **Marcas** - Si hay marcas configuradas
3. **Regalos Empresariales (Codefy)** - Si `settings.regalos_empresariales_show` está activado
4. **Banners Promocionales** - Si hay banners promocionales configurados

#### 4.5. Cómo encontrar otras secciones del home

Para agregar más secciones, revisa `snipplets/home/home-section-switch.tpl` para ver todas las secciones disponibles y cómo se incluyen.

---

### 5. Pasos en Tiendanube (admin)

1. Ir a **Contenido > Páginas > Nueva página**.
2. Nombre sugerido: “Corporativos”.
3. URL: `corporativo` (debe coincidir con `corporativos_page_url`).
4. Contenido: opcional (se mostrará dentro del template).
5. Marcar visible si se desea agregar al menú.

---

### 6. Checklist de QA

- [ ] Guardar cambios en el personalizador y publicar tema.
- [ ] Crear/actualizar la página `/corporativo`.
- [ ] Limpiar caché/forzar recarga para validar que se muestra el nuevo diseño.
- [ ] Revisar versiones desktop y mobile.
- [ ] Probar links/CTA y formularios.

---

### 5. Pasos en Tiendanube (admin)

1. Ir a **Contenido > Páginas > Nueva página**.
2. Nombre sugerido: "Corporativos".
3. URL: `corporativo` (debe coincidir con `corporativos_page_url`).
4. Contenido: opcional (se mostrará dentro del template).
5. Marcar visible si se desea agregar al menú.

---

### 6. Cómo activar las secciones en el personalizador

#### 6.1. Banner Custom (Codefy)
1. Ve a **Personalizar diseño** en Tiendanube
2. Busca la sección **"Banner Custom (Codefy)"**
3. Activa el checkbox **"Mostrar banner lateral"**
4. Configura imagen, título, descripción, botón, etc.

#### 6.2. Marcas
1. Ve a **Personalizar diseño > Página de inicio**
2. Busca la sección **"Marcas"**
3. Agrega imágenes de marcas en la galería
4. Configura título y formato (grid o slider)

#### 6.3. Regalos Empresariales (Codefy)
1. Ve a **Personalizar diseño**
2. Busca la sección **"Regalos Empresariales (Codefy)"**
3. Activa el checkbox **"Mostrar sección de regalos empresariales"**
4. Configura título, subtítulo, descripción, galería, etc.

#### 6.4. Banners Promocionales
1. Ve a **Personalizar diseño > Página de inicio**
2. Busca **"Banners promocionales"**
3. Agrega imágenes en la galería
4. Configura título, layout (grid o slider), columnas, etc.

---

### 7. Checklist de QA

- [ ] Guardar cambios en el personalizador y publicar tema.
- [ ] Crear/actualizar la página `/corporativo`.
- [ ] Activar las secciones deseadas en el personalizador.
- [ ] Verificar que los carruseles funcionan correctamente (navegación, paginación).
- [ ] Limpiar caché/forzar recarga para validar que se muestra el nuevo diseño.
- [ ] Revisar versiones desktop y mobile.
- [ ] Probar links/CTA y formularios.
- [ ] Verificar que todas las secciones se muestran en el orden correcto.

---

### 8. Resumen de archivos modificados

1. **`config/settings.txt`**: Agregar bloque `collapse` para configuración de página
2. **`config/defaults.txt`**: Agregar valores por defecto `corporativos_page_url` y `corporativos_page_title`
3. **`templates/page.tpl`**: Agregar detección de página y condición para no mostrar header
4. **`snipplets/page-corporativos.tpl`**: Template dedicado con secciones del home + JavaScript para carruseles

---

### 9. Próximos pasos

1. Implementar los cambios en código siguiendo esta guía.
2. Ajustar diseño y contenido según branding corporativo.
3. Documentar cualquier configuración adicional (ej. colecciones, banners específicos).

> **Nota importante**: Cuando el dominio final cambie, solo se debe asegurar que la página en Tiendanube mantenga el handle definido (`corporativo`). El template seguirá funcionando sin ajustes adicionales.

---

### 10. Guía rápida para crear otra landing similar

1. **Settings**: Agregar `{nombre}_page_url` y `{nombre}_page_title` en `settings.txt` y `defaults.txt`
2. **Detección**: Agregar `is_{nombre}_page` en `page.tpl`
3. **Template**: Crear `snipplets/page-{nombre}.tpl` con secciones del home
4. **JavaScript**: Agregar inicialización de carruseles si las secciones lo requieren
5. **Página**: Crear página en Tiendanube con la URL configurada

