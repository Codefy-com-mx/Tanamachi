# 🎯 Guía: Centrar Menú de Navegación en Desktop

## 📋 Descripción

Esta guía documenta cómo se implementó el centrado del menú de navegación en desktop y cómo aplicar este mismo cambio en futuras páginas o temas.

---

## 🔍 Implementación Actual

### Ubicación del Código

El centrado del menú se implementa en el archivo:
- **Archivo**: `snipplets/header/header.tpl`
- **Línea**: 188

### Código Implementado

```188:190:snipplets/header/header.tpl
<div class="container {{ show_block_desktop_hide_mobile_class }} {% if settings.logo_position_desktop == 'center' %}text-center{% endif %}">
    {% snipplet "navigation/navigation.tpl" %}
</div>
```

### Explicación

El centrado se logra mediante:

1. **Condición**: Se verifica si `settings.logo_position_desktop == 'center'`
2. **Clase aplicada**: Cuando la condición es verdadera, se aplica la clase `text-center`
3. **Resultado**: La clase `text-center` (de Bootstrap/estilos del tema) centra el contenido del contenedor, lo que a su vez centra el menú de navegación

### Estructura del Menú

El menú de navegación se renderiza dentro de un contenedor que:
- Solo se muestra en desktop (`show_block_desktop_hide_mobile_class`)
- Está dentro de un `container` para mantener el ancho máximo
- Se centra cuando el logo está configurado en posición `center` en desktop

---

## 🚀 Cómo Aplicar en Futuras Páginas

### Opción 1: Usar la Misma Lógica (Recomendado)

Si necesitas centrar el menú en otra página que use el mismo header, simplemente asegúrate de que:

1. **Configuración en Tiendanube**: 
   - Ve a **Diseño > Configuración del tema**
   - Configura `logo_position_desktop` en `center`

2. **El código ya está implementado**: 
   - El archivo `snipplets/header/header.tpl` ya contiene la lógica
   - Se aplicará automáticamente cuando la configuración esté en `center`

### Opción 2: Aplicar Manualmente en un Template Específico

Si necesitas centrar el menú solo en una página específica sin cambiar la configuración global:

1. **Localiza el template** donde quieres aplicar el cambio (ej: `templates/page.tpl`, `templates/category.tpl`, etc.)

2. **Busca la sección del header** o donde se incluye la navegación

3. **Aplica la clase `text-center`** al contenedor del menú:

```twig
<div class="container d-none d-md-block text-center">
    {% snipplet "navigation/navigation.tpl" %}
</div>
```

### Opción 3: Crear un Snippet Reutilizable

Si necesitas reutilizar esta funcionalidad en múltiples lugares:

1. **Crea un nuevo snippet** (opcional): `snipplets/navigation/navigation-centered.tpl`

```twig
{% set header_left_with_big_search = settings.logo_position_desktop == 'left' and settings.search_big_desktop %}
<div class="nav-desktop {% if header_left_with_big_search %}nav-desktop-left{% endif %}">
    <ul class="js-nav-desktop-list nav-desktop-list text-center" data-store="navigation" data-component="menu">
        <span class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-left nav-desktop-list-arrow nav-desktop-list-arrow-left disable" style="display: none">
            <svg class="icon-inline icon-lg icon-flip-horizontal"><use xlink:href="#chevron"/></svg>
        </span>
        {% include 'snipplets/navigation/navigation-nav-list.tpl' with {'megamenu' : true } %}
        <span class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-right nav-desktop-list-arrow nav-desktop-list-arrow-right" style="display: none">
            <svg class="icon-inline icon-lg"><use xlink:href="#chevron"/></svg>
        </span>
    </ul>
</div>
```

2. **Úsalo en el template** donde lo necesites:

```twig
<div class="container d-none d-md-block">
    {% snipplet "navigation/navigation-centered.tpl" %}
</div>
```

---

## 🎨 Estilos CSS Relacionados

### Clase `text-center`

La clase `text-center` está definida en los estilos del tema y aplica:

```css
.text-center {
    text-align: center !important;
}
```

### Estilos del Menú Desktop

Los estilos principales del menú desktop están en:
- **Archivo**: `static/css/style-critical.scss`
- **Líneas**: 1416-1520

```1416:1428:static/css/style-critical.scss
.nav-desktop {
  position: relative;
  width: 100%;
  height: 100%;
}

.nav-desktop-list {
  height: 100%;
  margin: 0;
  padding: 20px 0;
  list-style: none;
  white-space: nowrap!important;
}
```

---

## ✅ Checklist para Aplicar el Cambio

- [ ] Identificar la página/template donde se necesita centrar el menú
- [ ] Verificar si la configuración global (`logo_position_desktop == 'center'`) es suficiente
- [ ] Si no, aplicar la clase `text-center` manualmente en el contenedor del menú
- [ ] Verificar que el menú se centra correctamente en desktop (pantallas > 768px)
- [ ] Verificar que no afecta el diseño en mobile
- [ ] Probar en diferentes tamaños de pantalla

---

## 🔧 Variables y Configuraciones

### Variable de Configuración

- **Variable**: `settings.logo_position_desktop`
- **Valores posibles**: `'left'` | `'center'`
- **Ubicación**: Configuración del tema en Tiendanube

### Clases CSS Utilizadas

- `text-center`: Centra el texto/contenido
- `show_block_desktop_hide_mobile_class`: Muestra solo en desktop (`d-none d-md-block`)
- `container`: Limita el ancho máximo y centra el contenedor

---

## 🐛 Problemas Comunes y Soluciones

### Problema 1: El menú no se centra

**Solución**: 
- Verifica que la clase `text-center` esté aplicada al contenedor correcto
- Asegúrate de que el contenedor tenga `display: block` o `display: flex` con `justify-content: center`

### Problema 2: El menú se centra pero los items están alineados a la izquierda

**Solución**: 
- Verifica que `nav-desktop-list` tenga `text-align: center` o que los items estén dentro de un contenedor centrado
- Puede ser necesario agregar estilos adicionales:

```css
.nav-desktop-list.text-center {
  text-align: center;
}
```

### Problema 3: El centrado afecta el diseño en mobile

**Solución**: 
- Usa clases responsive: `text-center` solo en desktop con `text-md-center`
- O usa la clase condicional `show_block_desktop_hide_mobile_class` para que solo se aplique en desktop

---

## 📝 Notas Adicionales

- El centrado funciona mejor cuando el logo está en posición `center` en desktop
- Si el logo está en `left`, el menú normalmente se muestra al lado del logo, no debajo
- La clase `text-center` es una utilidad de Bootstrap que se puede sobrescribir con estilos personalizados si es necesario

---

## 🔗 Archivos Relacionados

- `snipplets/header/header.tpl` - Header principal donde se aplica el centrado
- `snipplets/navigation/navigation.tpl` - Componente del menú de navegación
- `snipplets/navigation/navigation-nav-list.tpl` - Lista de items del menú
- `static/css/style-critical.scss` - Estilos del menú desktop

---

**Última actualización**: 2024
**Versión del tema**: Scatola

