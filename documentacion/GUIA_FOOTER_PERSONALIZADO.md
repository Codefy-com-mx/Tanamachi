# 📚 Guía Completa: Footer Personalizado con Múltiples Menús - Tiendanube

## 🎯 Propósito de esta documentación

Esta guía te muestra paso a paso cómo personalizar el footer de un tema de Tiendanube para incluir:
- ✅ Múltiples columnas de menús configurables
- ✅ Newsletter personalizado con imágenes de fondo
- ✅ Layout responsive (desktop y móvil)
- ✅ Control total de estilos y textos

**Ideal para:**
- Migrar el footer personalizado a otro tema
- Entender cómo funciona el sistema de menús múltiples
- Personalizar el newsletter con imágenes y estilos
- Aprender sobre layouts flexbox avanzados

---

## 📋 Checklist de Archivos a Modificar/Crear

```
config/
├── settings.txt          [Líneas ~2730-2818] - Configuración de menús y newsletter
└── defaults.txt          [Líneas ~130-137] - Valores por defecto

snipplets/
├── footer/
│   └── footer.tpl        [Archivo completo] - Template principal del footer
└── navigation/
    └── navigation-foot.tpl  [Archivo completo] - Snippet reutilizable para menús
```

---

## 🏗️ Estructura General del Footer

El footer personalizado se divide en **3 secciones principales**:

1. **Sección Newsletter** (opcional, con imagen de fondo)
2. **Sección Principal** (logo + menús en columnas)
3. **Sección Powered By** (créditos y links legales)

```
┌─────────────────────────────────────────┐
│  NEWSLETTER SECTION                     │
│  - Título y subtítulo                   │
│  - Formulario de suscripción            │
│  - Tarjeta social (imagen + redes)       │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  FOOTER BOTTOM SECTION                 │
│  ┌──────────┐  ┌────────────────────┐ │
│  │  LOGO     │  │  MENÚ 1           │ │
│  │  +        │  │  MENÚ 2           │ │
│  │  CRÉDITOS │  │  MENÚ 3           │ │
│  └──────────┘  └────────────────────┘ │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│  POWERED BY SECTION                     │
│  - "Creado con Tiendanube"             │
│  - Logo desarrollador (opcional)       │
└─────────────────────────────────────────┘
```

---

## 🔧 Paso 1: Configuración en `settings.txt`

### 1.1 Sección de Menús

Agrega los campos de menú en la sección "Pie de página" → "Menúes":

```txt
title
	title = Menúes
subtitle
	subtitle = Elegí el menú para el final de la página (footer). Si aún no configuraste ninguno, podés hacerlo <a target='_blank' href='/admin/navigation/?ref=submenu'>desde acá</a>
checkbox
	name = footer_menu_show
	description = Mostrar menú

menu
	name = footer_menu
	description = ¿Qué menú vas a mostrar al final de la página?

subtitle
	subtitle = Podés sumar más columnas creando nuevos menús en la navegación y asignándolos acá.

menu
	name = footer_menu_company
	description = Menú para la columna "Compañía"

menu
	name = footer_menu_collections
	description = Menú para la columna "Colecciones"
```

**⚠️ IMPORTANTE:**
- Cada campo `menu` genera un selector en el admin
- Los menús deben crearse primero en **Navegación** del admin
- Los handles de los menús (ej: `footer-company`) deben coincidir con los nombres en Navegación

### 1.2 Sección de Newsletter

```txt
title
	title = Newsletter
checkbox
	name = news_show
	description = Permitir que tus clientes se registren para recibir novedades

i18n_input
	name = footer_newsletter_title
	description = Título del newsletter

i18n_input
	name = footer_newsletter_subtitle
	description = Subtítulo del newsletter

color
	name = footer_newsletter_bg_color
	description = Color de fondo del newsletter

color
	name = footer_newsletter_btn_color
	description = Color del botón de suscripción

i18n_input
	name = footer_newsletter_social_text
	description = Texto de redes sociales

image
	title = Imagen de fondo del newsletter (con decoraciones incluidas)
	original = footer_newsletter_bg.jpg
	width = 1920
	height = 600

image
	title = Imagen de fondo del newsletter para móvil (opcional)
	original = footer_newsletter_bg_mobile.jpg
	width = 768
	height = 600

image
	title = Imagen central del newsletter (caja de regalo)
	original = footer_newsletter_image.jpg
	width = 300
	height = 300
```

**Características:**
- `i18n_input` genera variables con sufijos `_es`, `_en`, `_pt`
- Las imágenes deben tener `original = nombre_archivo.jpg` (OBLIGATORIO)
- Puedes tener imágenes diferentes para desktop y móvil

---

## 📝 Paso 2: Valores por Defecto en `defaults.txt`

**CADA** campo en `settings.txt` debe tener un valor por defecto:

```txt
# Menús
footer_menu = navigation
footer_menu_show = 1
footer_menu_company = footer-company
footer_menu_collections = footer-collections

# Newsletter - Textos (multiidioma)
footer_newsletter_title_es = ¡No Te Pierdas Nada!
footer_newsletter_title_en = Don't Miss Anything!
footer_newsletter_title_pt = Não Perca Nada!

footer_newsletter_subtitle_es = Promociones, descuentos, noticias, lanzamientos, y nada de spam. ¡Déjanos tu correo!
footer_newsletter_subtitle_en = Promotions, discounts, news, launches, and no spam. Leave us your email!
footer_newsletter_subtitle_pt = Promoções, descontos, notícias, lançamentos e sem spam. Deixe-nos seu e-mail!

# Newsletter - Colores
footer_newsletter_bg_color = #E8F5B5
footer_newsletter_btn_color = #B3E5FC

# Newsletter - Texto redes sociales
footer_newsletter_social_text_es = Síguenos en nuestras redes sociales.
footer_newsletter_social_text_en = Follow us on our social networks.
footer_newsletter_social_text_pt = Siga-nos em nossas redes sociais.
```

**⚠️ IMPORTANTE:**
- Los campos `menu` usan el **handle** del menú (ej: `footer-company`)
- Los campos `i18n_input` necesitan valores por idioma con sufijos `_es`, `_en`, `_pt`
- Los colores pueden ser hex (`#E8F5B5`) o rgba

---

## 🎨 Paso 3: Template del Footer (`snipplets/footer/footer.tpl`)

### 3.1 Variables y Preparación de Datos

Al inicio del archivo, prepara las variables para los menús:

```twig
{# Detección de logo #}
{% set has_footer_logo = "footer_logo.jpg" | has_custom_image %}

{# Menú Principal #}
{% set footer_primary_menu_handle = settings.footer_menu %}
{% if footer_primary_menu_handle is iterable and footer_primary_menu_handle.handle is defined %}
	{% set footer_primary_menu_handle = footer_primary_menu_handle.handle %}
{% endif %}
{% set has_footer_menu_handle = footer_primary_menu_handle %}

{# Menú Compañía #}
{% set footer_company_menu_handle = settings.footer_menu_company %}
{% if footer_company_menu_handle is iterable and footer_company_menu_handle.handle is defined %}
	{% set footer_company_menu_handle = footer_company_menu_handle.handle %}
{% endif %}
{% set has_footer_company_handle = footer_company_menu_handle %}

{# Menú Colecciones #}
{% set footer_collections_menu_handle = settings.footer_menu_collections %}
{% if footer_collections_menu_handle is iterable and footer_collections_menu_handle.handle is defined %}
	{% set footer_collections_menu_handle = footer_collections_menu_handle.handle %}
{% endif %}
{% set has_footer_collections_handle = footer_collections_menu_handle %}

{# Variables Newsletter #}
{% set newsletter_title = settings.footer_newsletter_title | default('¡No Te Pierdas Nada!') %}
{% set newsletter_subtitle = settings.footer_newsletter_subtitle | default('Promociones, descuentos, noticias, lanzamientos, y nada de spam. ¡Déjanos tu correo!') %}
{% set newsletter_bg_color = settings.footer_newsletter_bg_color | default('#E8F5B5') %}
{% set newsletter_btn_color = settings.footer_newsletter_btn_color | default('#B3E5FC') %}
{% set newsletter_social_text = settings.footer_newsletter_social_text | default('Síguenos en nuestras redes sociales.') %}

{# Imágenes Newsletter #}
{% set has_newsletter_bg = "footer_newsletter_bg.jpg" | has_custom_image %}
{% set has_newsletter_bg_mobile = "footer_newsletter_bg_mobile.jpg" | has_custom_image %}
{% set has_newsletter_image = "footer_newsletter_image.jpg" | has_custom_image %}
```

**⚠️ IMPORTANTE - Manejo de Menús:**
- Tiendanube puede devolver los campos `menu` como objetos con propiedad `handle`
- Siempre verifica si es iterable y extrae el `handle` antes de usarlo
- Esto evita errores cuando el admin asigna un menú

### 3.2 Sección Newsletter

```twig
{% if settings.news_show and template != 'password' %}
	{# Construir estilos inline para fondo #}
	{% set footer_newsletter_style = "--newsletter-bg-color: " ~ newsletter_bg_color ~ "; background-color: " ~ newsletter_bg_color ~ ";" %}
	{% if has_newsletter_bg %}
		{% set footer_newsletter_style = footer_newsletter_style ~ " --newsletter-bg-desktop: url('" ~ ('footer_newsletter_bg.jpg' | static_url) ~ "');" %}
	{% endif %}
	{% if has_newsletter_bg_mobile %}
		{% set footer_newsletter_style = footer_newsletter_style ~ " --newsletter-bg-mobile: url('" ~ ('footer_newsletter_bg_mobile.jpg' | static_url) ~ "');" %}
	{% endif %}

	<section class="footer-newsletter-section {% if has_newsletter_bg_mobile %}has-mobile-bg{% endif %}" 
		style="{{ footer_newsletter_style }}">
		<div class="container position-relative">
			<div class="footer-newsletter-content text-center">
				<h2 class="footer-newsletter-title">{{ newsletter_title | translate }}</h2>
				<p class="footer-newsletter-subtitle">{{ newsletter_subtitle | translate }}</p>
				
				{# Formulario de suscripción #}
				{% include 'snipplets/newsletter.tpl' with {footer_style: true, btn_color: newsletter_btn_color} %}
				
				{# Tarjeta social con imagen y redes #}
				<div class="footer-social-card">
					<div class="row align-items-center">
						<div class="col-md-4 text-md-left text-center mb-3 mb-md-0">
							<p class="footer-social-card-text">{{ newsletter_social_text | translate }}</p>
						</div>
						
						{% if has_newsletter_image %}
						<div class="col-md-4 text-center mb-3 mb-md-0 footer-social-card-image-col">
							<img src="{{ 'footer_newsletter_image.jpg' | static_url }}" alt="{{ store.name }}" class="footer-social-card-image lazyload">
						</div>
						{% endif %}
						
						<div class="col-md-4 text-md-right text-center">
							{% if has_social_network %}
								{% include "snipplets/social/social-links.tpl" with {footer_newsletter: true} %}
							{% endif %}
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
{% endif %}
```

**Características:**
- Usa variables CSS (`--newsletter-bg-desktop`, `--newsletter-bg-mobile`) para imágenes de fondo
- La clase `has-mobile-bg` permite aplicar imagen diferente en móvil
- El formulario recibe `btn_color` como parámetro para personalizar el botón

### 3.3 Sección Principal (Logo + Menús)

```twig
<div class="container footer-bottom-section codefy-footer">
	<div class="footer-bottom-grid">
		
		{# Columna izquierda - Logo y créditos #}
		<div class="footer-left-col footer-brand-block text-md-left text-center">
			{% if has_footer_logo and template != 'password' %}
				<div class="mb-3 footer-logo-wrapper">
					<img src="{{ 'images/empty-placeholder.png' | static_url }}" 
					     data-src="{{ 'footer_logo.jpg' | static_url('large') }}" 
					     alt="{{ store.name }}" 
					     title="{{ store.name }}" 
					     class="footer-logo-img lazyload">
				</div>
			{% endif %}
			
			<div class="footer-credits font-smallest mb-3">
				<p class="mb-1">{{ "Copyright {1} - {2}. Todos los derechos reservados." | translate( (store.business_name ? store.business_name : store.name) ~ (store.business_id ? ' - ' ~ store.business_id : ''), "now" | date('Y') ) }}</p>
				<p class="mb-0">Designed by Codefy</p>
			</div>
		</div>
		
		{# Columnas derechas - Menús #}
		{% set should_render_footer_menus = template != 'password' and settings.footer_menu_show %}
		
		{% if should_render_footer_menus %}
			<div class="footer-menu-wrapper">
				{% if has_footer_menu_handle %}
					<div class="footer-menu-col footer-menu-col--primary">
						<h4 class="footer-menu-title">Ayuda + Info</h4>
						{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_primary_menu_handle} %}
					</div>
				{% endif %}
				
				{% if has_footer_company_handle %}
					<div class="footer-menu-col footer-menu-col--company">
						<h4 class="footer-menu-title">Compañía</h4>
						{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_company_menu_handle} %}
					</div>
				{% endif %}
				
				{% if has_footer_collections_handle %}
					<div class="footer-menu-col footer-menu-col--collections">
						<h4 class="footer-menu-title">Colecciones</h4>
						{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_collections_menu_handle} %}
					</div>
				{% endif %}
			</div>
		{% endif %}
		
	</div>
</div>
```

**Estructura:**
- `.footer-bottom-grid` es el contenedor flex principal
- `.footer-left-col` contiene logo y créditos (20% aprox)
- `.footer-menu-wrapper` contiene todas las columnas de menús (50% aprox, empujado a la derecha)
- Cada `.footer-menu-col` es una columna individual con título y lista

---

## 🧩 Paso 4: Snippet de Navegación Reutilizable

Crea o modifica `snipplets/navigation/navigation-foot.tpl`:

```twig
{% set resolved_handle = menu_handle | default(settings.footer_menu) %}
{% set menu_items = resolved_handle and menus[resolved_handle] is defined ? menus[resolved_handle] : [] %}

{% if menu_items and menu_items | length > 0 %}
<ul class="list py-2 font-small">
	{% for item in menu_items %}
		<li class="footer-menu-item{% if loop.last %} mb-2{% endif %}">
	        <a class="footer-menu-link" href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %}>{{ item.name }}</a>
		</li>
	{% endfor %}
</ul>
{% endif %}
```

**Características:**
- Acepta `menu_handle` como parámetro opcional
- Si no se pasa, usa `settings.footer_menu` por defecto
- Verifica que el menú exista antes de renderizar
- Maneja enlaces externos automáticamente

**Uso:**
```twig
{# Menú principal #}
{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_primary_menu_handle} %}

{# Menú secundario #}
{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_company_menu_handle} %}
```

---

## 🎨 Paso 5: Estilos CSS

### 5.1 Estilos Desktop (≥ 1024px)

```css
/* Contenedor principal con max-width */
.codefy-footer {
	max-width: 1240px;
	margin: 0 auto;
}

/* Grid principal - una fila flex */
.footer-bottom-grid {
	display: flex;
	gap: 2rem;
	align-items: flex-start;
	justify-content: space-between;
}

/* Columna izquierda - Logo y créditos */
.footer-left-col {
	flex: 0 0 auto;
	max-width: 240px;
	text-align: left;
}

.footer-logo-img {
	max-height: 80px;
	width: auto;
	height: auto;
}

/* Wrapper de menús - empujado a la derecha */
.footer-menu-wrapper {
	flex: 1;
	margin-left: auto;
	display: flex;
	gap: 2.5rem;
	justify-content: flex-end;
}

/* Cada columna de menú */
.footer-menu-col {
	text-align: left;
	min-width: 120px;
	flex: 1;
}

.footer-menu-title {
	font-size: 1.125rem;
	font-weight: 600;
	color: #000;
	margin-bottom: 1rem;
}

/* Lista de enlaces - vertical */
.footer-menu-col ul {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.footer-menu-link {
	color: #666;
	text-decoration: none;
	font-size: 0.95rem;
	line-height: 1.5;
	display: inline-block;
	transition: color 0.3s ease;
}

.footer-menu-link:hover {
	color: #000;
}
```

**Características del Layout Desktop:**
- Logo ocupa ~240px fijos a la izquierda
- Menús se empujan a la derecha con `margin-left: auto`
- Gap moderado entre columnas (2.5rem)
- Listas verticales con spacing compacto

### 5.2 Estilos Newsletter

```css
.footer-newsletter-section {
	padding: 4rem 0 3rem;
	position: relative;
	overflow: hidden;
	background-size: cover;
	background-position: center top;
	background-repeat: no-repeat;
}

/* Imagen de fondo desktop */
.footer-newsletter-section:not(.has-mobile-bg) {
	background-image: var(--newsletter-bg-desktop);
}

/* Imagen de fondo cuando existe versión móvil */
.footer-newsletter-section.has-mobile-bg {
	background-image: var(--newsletter-bg-desktop);
}

.footer-newsletter-title {
	font-size: 2.5rem;
	font-weight: 700;
	color: #000;
	margin-bottom: 0.75rem;
	line-height: 1.2;
}

.footer-newsletter-subtitle {
	font-size: 1rem;
	color: #333;
	margin-bottom: 1.5rem;
	line-height: 1.6;
}

/* Tarjeta social */
.footer-social-card {
	background: rgba(255, 255, 255, 0.8);
	background: linear-gradient(135deg, #F5F1E8 0%, #EDE7DB 100%);
	border-radius: 30px;
	padding: 1.5rem 3rem;
	margin-top: 8rem;
	margin-bottom: 2rem;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	backdrop-filter: blur(10px);
	max-height: 6rem;
	display: flex;
	align-items: center;
}
```

### 5.3 Estilos Mobile (≤ 767px)

```css
@media (max-width: 767px) {
	/* Footer bottom section */
	.footer-bottom-section {
		padding: 2rem 0 1.5rem;
	}
	
	.footer-bottom-grid {
		flex-direction: column;
		align-items: center;
		text-align: center;
	}
	
	/* Todas las columnas ocupan 100% */
	.footer-left-col,
	.footer-menu-wrapper,
	.footer-menu-col {
		flex: 0 0 100%;
		max-width: 100%;
		width: 100%;
		text-align: center;
	}
	
	/* Menús apilados verticalmente */
	.footer-menu-wrapper {
		flex-direction: column;
		gap: 0.7rem;
		align-items: stretch;
	}
	
	/* Padding izquierdo para menús */
	.footer-menu-col {
		text-align: left;
		padding: 0 12px;
	}
	
	.footer-menu-title {
		text-align: left;
		margin-bottom: 0.25rem;
	}
	
	/* Links más compactos */
	.footer-menu-col ul {
		width: 100%;
		gap: 0.1rem;
	}
	
	/* Newsletter - imagen de fondo para todo el footer */
	.footer-newsletter-section {
		background-size: cover !important;
		background-position: center !important;
	}
	
	/* Cambiar a imagen móvil si existe */
	.footer-newsletter-section.has-mobile-bg {
		background-image: var(--newsletter-bg-mobile) !important;
	}
	
	/* Aplicar fondo también al footer bottom en móvil */
	.footer-bottom-section.codefy-footer {
		background-size: cover;
		background-position: center;
		background-repeat: no-repeat;
	}
	
	{% if has_newsletter_bg_mobile %}
	.footer-bottom-section.codefy-footer {
		background-image: var(--newsletter-bg-mobile);
	}
	{% elseif has_newsletter_bg %}
	.footer-bottom-section.codefy-footer {
		background-image: var(--newsletter-bg-desktop);
	}
	{% endif %}
}
```

**Características Mobile:**
- Todo se apila verticalmente
- Menús con padding izquierdo para no pegarse al borde
- Spacing muy compacto entre elementos
- Imagen de fondo aplicada a todo el footer (newsletter + bottom)

---

## 🔄 Flujo de Trabajo Completo

### Paso 1: Crear los Menús en el Admin
1. Ve a **Navegación** en el admin de Tiendanube
2. Crea los menús necesarios:
   - `footer` (o el nombre que uses)
   - `footer-company`
   - `footer-collections`
3. Agrega los enlaces a cada menú

### Paso 2: Configurar en el Personalizador
1. Ve a **Personalizador** → **Pie de página**
2. Activa "Mostrar menú"
3. Asigna cada menú a su selector correspondiente
4. Configura textos y colores del newsletter
5. Sube las imágenes de fondo (desktop y móvil opcional)

### Paso 3: Verificar en el Frontend
1. Desktop: Logo a la izquierda, menús a la derecha
2. Mobile: Todo apilado, fondo aplicado a todo el footer
3. Newsletter: Imagen de fondo visible, formulario funcional

---

## 🎯 Personalización Avanzada

### Agregar Más Columnas de Menús

1. **En `settings.txt`:**
```txt
menu
	name = footer_menu_extra
	description = Menú para la columna "Extra"
```

2. **En `defaults.txt`:**
```txt
footer_menu_extra = footer-extra
```

3. **En `footer.tpl` - Variables:**
```twig
{% set footer_extra_menu_handle = settings.footer_menu_extra %}
{% if footer_extra_menu_handle is iterable and footer_extra_menu_handle.handle is defined %}
	{% set footer_extra_menu_handle = footer_extra_menu_handle.handle %}
{% endif %}
{% set has_footer_extra_handle = footer_extra_menu_handle %}
```

4. **En `footer.tpl` - Render:**
```twig
{% if has_footer_extra_handle %}
	<div class="footer-menu-col footer-menu-col--extra">
		<h4 class="footer-menu-title">Extra</h4>
		{% include "snipplets/navigation/navigation-foot.tpl" with {menu_handle: footer_extra_menu_handle} %}
	</div>
{% endif %}
```

### Cambiar Títulos de las Columnas

Los títulos están hardcodeados en el template. Para hacerlos configurables:

1. **En `settings.txt`:**
```txt
i18n_input
	name = footer_menu_primary_title
	description = Título de la primera columna
```

2. **En `defaults.txt`:**
```txt
footer_menu_primary_title_es = Ayuda + Info
footer_menu_primary_title_en = Help + Info
```

3. **En `footer.tpl`:**
```twig
<h4 class="footer-menu-title">{{ settings.footer_menu_primary_title | translate }}</h4>
```

### Modificar Layout Desktop

Para cambiar proporciones (ej: 30% logo, 70% menús):

```css
.footer-left-col {
	flex: 0 0 30%;
	max-width: 30%;
}

.footer-menu-wrapper {
	flex: 0 0 70%;
	max-width: 70%;
}
```

Para centrar los menús en lugar de empujarlos a la derecha:

```css
.footer-menu-wrapper {
	margin-left: 0; /* Quitar auto */
	justify-content: center; /* Centrar */
}
```

---

## 🐛 Problemas Comunes y Soluciones

### ❌ Los menús no se muestran

**Causa:** El handle del menú no coincide con el nombre en Navegación

**Solución:**
1. Verifica en Navegación el nombre exacto del menú
2. Asegúrate que en `defaults.txt` uses el mismo handle
3. Verifica que el menú tenga al menos un enlace

**Debug:**
```twig
<pre>{{ settings.footer_menu | json_encode }}</pre>
<pre>{{ menus | keys | json_encode }}</pre>
```

### ❌ Imágenes de fondo no aparecen

**Causa A:** Falta `original = nombre.jpg` en `settings.txt`

**Solución:**
```txt
image
	original = footer_newsletter_bg.jpg  # ← OBLIGATORIO
	name = footer_newsletter_bg
```

**Causa B:** La imagen no se subió correctamente

**Solución:** Verifica en el admin que la imagen esté guardada

### ❌ Layout se rompe en mobile

**Causa:** Falta `flex-direction: column` en el wrapper

**Solución:**
```css
@media (max-width: 767px) {
	.footer-menu-wrapper {
		flex-direction: column; /* ← CRÍTICO */
	}
}
```

### ❌ Menús muy separados en desktop

**Causa:** Gap muy grande entre columnas

**Solución:**
```css
.footer-menu-wrapper {
	gap: 2.5rem; /* Reducir a 1.5rem o menos */
}
```

### ❌ Newsletter no se muestra

**Causa:** Checkbox `news_show` desactivado

**Solución:** Activa "Permitir que tus clientes se registren para recibir novedades" en el admin

---

## 📊 Estructura de Archivos Final

```
config/
├── settings.txt
│   └── [Líneas 2730-2818] Configuración footer
└── defaults.txt
    └── [Líneas 130-137] Valores por defecto

snipplets/
├── footer/
│   └── footer.tpl          [~700 líneas] Template completo
└── navigation/
    └── navigation-foot.tpl  [~12 líneas] Snippet reutilizable
```

---

## ✅ Checklist de Migración

- [ ] Agregar campos `menu` en `settings.txt` (uno por columna)
- [ ] Agregar valores por defecto en `defaults.txt`
- [ ] Crear/modificar `navigation-foot.tpl` para aceptar `menu_handle`
- [ ] Modificar `footer.tpl` con variables de menús
- [ ] Agregar sección newsletter con imágenes de fondo
- [ ] Implementar layout desktop (flexbox, logo izquierda, menús derecha)
- [ ] Implementar layout mobile (apilado, compacto)
- [ ] Agregar estilos CSS (desktop y mobile)
- [ ] Crear menús en el admin de Tiendanube
- [ ] Asignar menús en el personalizador
- [ ] Probar en desktop (≥ 1024px)
- [ ] Probar en mobile (≤ 767px)
- [ ] Verificar imágenes de fondo (desktop y móvil)
- [ ] Verificar formulario de newsletter

---

## 🎓 Mejores Prácticas

1. **Siempre verifica handles de menús:**
   - Tiendanube puede devolver objetos, no solo strings
   - Usa la verificación `is iterable` antes de acceder

2. **Usa clases específicas:**
   - Prefijo `codefy-footer` o similar para evitar conflictos
   - Clases BEM (`footer-menu-col--primary`) para organización

3. **Mobile First:**
   - Define estilos móviles primero
   - Sobrescribe con media queries para desktop

4. **Imágenes optimizadas:**
   - Desktop: 1920x600px (fondo completo)
   - Mobile: 768x600px (optimizado para pantallas pequeñas)

5. **Lazy loading:**
   - Usa `lazyload` en todas las imágenes
   - Placeholder mientras carga

---

## 📚 Recursos Adicionales

- **Documentación Tiendanube:** https://github.com/TiendaNube/api-docs
- **Twig Documentation:** https://twig.symfony.com/doc/
- **Flexbox Guide:** https://css-tricks.com/snippets/css/a-guide-to-flexbox/

---

**🎉 ¡Ahora tienes todo el conocimiento para personalizar el footer en cualquier tema de Tiendanube!**

**Última actualización:** Diciembre 2024  
**Versión:** 1.0.0

