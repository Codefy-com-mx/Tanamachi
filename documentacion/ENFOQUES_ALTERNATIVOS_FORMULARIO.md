# 🔍 Enfoques Alternativos: Por qué el Formulario No Funciona

## 🎯 Problema Principal

El formulario en la home no está enviando correctamente. La página se refresca pero no se ve el POST en Network.

## 💡 Enfoques Alternativos a Investigar

### ENFOQUE 1: Redirección Después del Submit ⭐⭐⭐
**HIPÓTESIS:** Tiendanube puede estar redirigiendo a otra página después de procesar `/winnie-pooh`, perdiendo el contexto de la home.

**SÍNTOMAS:**
- La página se refresca
- No aparece el POST en Network (puede ser que redirija antes)
- No se ven mensajes de éxito/error

**SOLUCIÓN PROPUESTA:**
Agregar un campo oculto que indique la URL de retorno:
```twig
<input type="hidden" name="return_url" value="{{ store.url }}{{ '/' }}" />
```

O verificar si Tiendanube soporta parámetros de redirección en el formulario.

---

### ENFOQUE 2: Variable `contact` No Disponible en Home
**HIPÓTESIS:** La variable `contact` solo está disponible en `templates/contact.tpl`, no en `templates/home.tpl`.

**EVIDENCIA:**
- En `contact.tpl` funciona: `{% if contact %}`
- En `home.tpl` puede que no exista la variable `contact`

**SOLUCIÓN PROPUESTA:**
Verificar si la variable `contact` está disponible en el contexto de la home. Si no, necesitamos usar parámetros de URL para detectar el resultado del envío.

---

### ENFOQUE 3: Campo Oculto `from` o Contexto
**HIPÓTESIS:** Tiendanube puede necesitar saber desde dónde viene el formulario para procesarlo correctamente.

**SOLUCIÓN PROPUESTA:**
Agregar campos ocultos adicionales:
```twig
<input type="hidden" name="from" value="home" />
<input type="hidden" name="page" value="home" />
```

---

### ENFOQUE 4: JavaScript Interceptando Globalmente
**HIPÓTESIS:** Algún JavaScript global está interceptando TODOS los formularios y previniendo el submit.

**EVIDENCIA ENCONTRADA:**
- `jQueryNuvem(".js-product-form").on("submit", function (e) { ... })`
- Puede haber listeners globales que intercepten formularios

**SOLUCIÓN PROPUESTA:**
Usar un form sin clases que puedan ser interceptadas, o usar un approach completamente diferente (AJAX manual).

---

### ENFOQUE 5: Newsletter Borra el Action
**EVIDENCIA ENCONTRADA:**
Los formularios de newsletter tienen: `onsubmit="this.setAttribute('action', '');"`

Esto **borra el action** antes de enviar. ¿Es esto necesario? ¿Por qué lo hacen?

**PREGUNTA:** ¿Necesitamos hacer lo mismo con nuestro formulario?

---

### ENFOQUE 6: Diferencia en el Contexto de Renderizado
**HIPÓTESIS:** El formulario en la home se renderiza dentro de un loop o contexto diferente que puede afectar cómo se procesa.

**EVIDENCIA:**
- El formulario está en `snipplets/home/home-formulario.tpl`
- Se incluye en `home-section-switch.tpl` dentro de un loop `{% for i in 1..18 %}`
- Esto puede crear problemas de contexto

**SOLUCIÓN PROPUESTA:**
Mover el formulario fuera del loop o usar un contexto diferente.

---

### ENFOQUE 7: El Formulario Necesita Estar en una Página Dedicada
**HIPÓTESIS:** Tiendanube solo procesa correctamente formularios de contacto en la página `/contacto`.

**SOLUCIÓN PROPUESTA:**
Crear una página dedicada para el formulario y usar un iframe o redirigir a esa página.

---

### ENFOQUE 8: Problema con `data-store` Attribute
**HIPÓTESIS:** El atributo `data-store` puede estar causando que algún JavaScript intercepte el formulario.

**EVIDENCIA:**
- Newsletter usa: `data-store="newsletter-form"`
- Nuestro formulario usa: `data-store="home-formulario"`
- Contact usa: `data-store="contact-form"`

**SOLUCIÓN PROPUESTA:**
Probar sin el atributo `data-store` o cambiarlo.

---

### ENFOQUE 9: AJAX Manual en Lugar de POST Normal
**HIPÓTESIS:** El formulario necesita enviarse vía AJAX en lugar de POST normal para funcionar en la home.

**SOLUCIÓN PROPUESTA:**
Implementar envío AJAX manual a `/winnie-pooh` y manejar la respuesta manualmente.

---

### ENFOQUE 10: Verificar si el Formulario Realmente Se Renderiza
**HIPÓTESIS:** El formulario puede no estar renderizándose correctamente en el DOM.

**SOLUCIÓN PROPUESTA:**
1. Verificar en las DevTools que el formulario existe en el DOM
2. Verificar que tiene los atributos correctos (`method="post"`, `action="/winnie-pooh"`)
3. Verificar que los campos tienen los `name` correctos
4. Inspeccionar el HTML renderizado completo

---

## 🎯 PRIORIDAD DE INVESTIGACIÓN

1. **ENFOQUE 1** (Redirección) - ⭐⭐⭐ MÁS PROBABLE
2. **ENFOQUE 2** (Variable contact) - ⭐⭐ MUY PROBABLE
3. **ENFOQUE 10** (Verificar renderizado) - ⭐⭐ PRIMERO VERIFICAR
4. **ENFOQUE 4** (JavaScript interceptando) - ⭐ POSIBLE
5. **ENFOQUE 8** (data-store) - ⭐ POSIBLE

---

## 🔧 PLAN DE ACCIÓN

1. **PASO 1:** Verificar en DevTools el HTML renderizado del formulario
2. **PASO 2:** Agregar campo oculto con URL de retorno
3. **PASO 3:** Verificar si `contact` está disponible usando `{{ dump(contact) }}`
4. **PASO 4:** Probar sin `data-store`
5. **PASO 5:** Si nada funciona, implementar AJAX manual

