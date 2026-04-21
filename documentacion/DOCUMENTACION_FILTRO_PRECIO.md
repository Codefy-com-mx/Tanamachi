# Guía Técnica: Filtro de Rango de Precios (Tiendanube)

Este documento explica el funcionamiento, implementación y personalización del filtro nativo de rango de precios en el tema Aguiar.

---

## 1. Implementación Básica

En Tiendanube, el filtro de precio es un **Componente Nativo**. Para renderizarlo, se utiliza la función `component()` dentro de los archivos de plantilla (generalmente en `snipplets/grid/filters.tpl`).

### Código de Implementación:

```twig
{{ component(
    'price-filter',
    {
        'group_class': 'price-filter-container mb-3 pb-1',
        'title_class': 'font-small font-weight-bold mb-4',
        'button_class': 'btn btn-default d-inline-block' 
    }
) }}
```

### Parámetros del Componente:
*   **group_class:** Clase CSS para el contenedor principal del filtro.
*   **title_class:** Clase CSS para el título (ej: "Precio").
*   **button_class:** Clase para el botón de "Aplicar" o "Filtrar".

---

## 2. Lógica de Funcionamiento (Backend)

El valor mínimo y máximo **no es estático**. El motor de Tiendanube lo calcula dinámicamente siguiendo estas reglas:

1.  **Detección de Contexto:** El sistema identifica en qué página está el usuario (`category.tpl`, `search.tpl` o `index.tpl`).
2.  **Cálculo de Rango:** Analiza el conjunto de productos disponibles en esa vista específica y busca el `MIN(price)` y `MAX(price)`.
3.  **Inyección de Datos:** El componente recibe automáticamente estos valores y configura los límites del slider o los inputs.

> [!NOTE]
> Si una categoría solo tiene productos de un mismo precio, el filtro de precio podría no mostrarse ya que el rango es cero.

---

## 3. Acceso a los Valores Manualmente (Twig)

Si necesitas acceder a los datos del filtro fuera del componente nativo (por ejemplo, para crear un diseño 100% personalizado), puedes iterar sobre el objeto global `product_filters`:

```twig
{% for filter in product_filters %}
    {% if filter.type == 'price' %}
        {# Aquí tienes acceso a la configuración del filtro de precio #}
        <span>El precio mínimo en esta sección es: {{ filter.min_price }}</span>
        <span>El precio máximo en esta sección es: {{ filter.max_price }}</span>
    {% endif %}
{% endfor %}
```

---

## 4. Funcionamiento de los Filtros (URL + AJAX)

El filtrado ocurre mediante parámetros en la URL. Cuando el usuario aplica un rango, el sistema añade:
`?price_min=100&price_max=500`

### Interacción con JS:
En `static/js/store.js.tpl`, la lógica de filtros utiliza las funciones globales de Tiendanube:
*   `LS.urlAddParam('price_min', valor)`
*   `LS.urlAddParam('price_max', valor)`

Esto dispara una petición AJAX que recarga la grilla de productos (`.js-product-table`) sin refrescar toda la página.

---

## 5. Estilos Recomendados (CSS)

Para que el filtro se integre perfectamente con un diseño premium, puedes atacar estas clases en tu SCSS:

```scss
/* Contenedor del filtro */
.price-filter-container {
    padding: 15px 0;
}

/* Inputs de precio */
.filter-input {
    border: 1px solid var(--main-foreground-opacity-10);
    border-radius: 4px;
    padding: 8px;
}

/* Botón de filtrar dentro del componente */
.price-filter-container .btn {
    text-transform: uppercase;
    font-size: 11px;
    letter-spacing: 1px;
}
```

---

## 6. Portabilidad a otros Proyectos

Para replicar este comportamiento en otro proyecto de Tiendanube:
1. Asegúrate de que los filtros estén activados en el Panel Admin (**Marketing > Filtros**).
2. Copia el llamado al `component('price-filter', ...)` en tu archivo de filtros.
3. Asegúrate de incluir el archivo `static/js/store.js.tpl` (o el equivalente que maneje los filtros AJAX) para que los botones de aplicar funcionen.
