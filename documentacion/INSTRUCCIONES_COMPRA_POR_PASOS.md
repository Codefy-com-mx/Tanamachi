# 📦 Instrucciones: Página de Compra por Pasos

## 🎯 ¿Qué se implementó?

Se creó una **página independiente** para la funcionalidad "Compra por Pasos", que permite a los usuarios:
- Acceder a la funcionalidad desde una URL específica (ej: `/compra-pasos`)
- Tener una experiencia dedicada sin estar en el home
- Compartir el enlace directo a la página de packs personalizados

---

## 📋 Pasos para activar la página

### **1. Configurar en el Personalizador del Tema**

1. Ve a **Personalizar diseño** en tu panel de Tiendanube
2. Busca la sección **"Páginas personalizadas (Codefy)"**
3. Configura:
   - **URL de la página**: Ej: `compra-pasos`, `arma-tu-pack`, `crea-tu-pack` (sin la `/`)
   - **Título de la página**: Ej: "Crea tu Pack Personalizado" (opcional)
4. Guarda los cambios

### **2. Crear la página en Tiendanube**

1. Ve a **Contenido** > **Páginas** en tu panel de Tiendanube
2. Haz clic en **"Crear página"**
3. Completa los datos:
   - **Nombre**: "Compra por Pasos" (o el que prefieras)
   - **URL**: Escribe la **misma URL** que configuraste en el paso 1
     - ⚠️ **IMPORTANTE**: Debe coincidir exactamente con la URL del personalizador
     - Ejemplo: Si pusiste `arma-tu-pack` en el personalizador, usa `arma-tu-pack` aquí
   - **Contenido**: Puedes dejarlo vacío (el contenido se genera automáticamente)
4. Marca como **"Visible"** si quieres que aparezca en el menú
5. Guarda la página

**Nota**: No hay selector de templates. El sistema detecta automáticamente la página por la URL que configuraste.

### **3. Configurar productos con tags**

Para que los productos aparezcan en cada paso, deben tener las etiquetas correctas:

- **Paso 1**: Productos con tag `paso_1` (o el configurado en el personalizador)
- **Paso 2**: Productos con tag `paso_2`
- **Paso 3**: Productos con tag `paso_3`

**¿Cómo agregar tags?**
1. Ve a **Productos** en tu panel
2. Edita un producto
3. En **"Etiquetas"**, agrega el tag correspondiente (ej: `paso_1`)
4. Guarda el producto

---

## 🚀 ¿Cómo acceder a la página?

Una vez configurada, la página estará disponible en:
```
https://tu-tienda.mitiendanube.com/[tu-url-configurada]
```
Ejemplo: `https://tu-tienda.mitiendanube.com/compra-pasos`

También puedes:
- Agregarla al menú de navegación
- Crear un banner que enlace a ella
- Compartir el enlace directo en redes sociales

---

## ⚙️ Configuración de la sección

### **En el Home**
La sección "Compra por Pasos (Codefy)" sigue disponible en el home. Puedes:
- **Mantenerla en el home**: Ideal si quieres que los usuarios la vean al entrar
- **Quitarla del home**: Si prefieres que solo esté en la página dedicada

### **Configuración de pasos**
En **"Compra por Pasos (Codefy)"** del personalizador puedes configurar:
- Títulos y descripciones de cada paso (multiidioma)
- Tags de productos para cada paso
- Máximo de productos por paso (1-5)
- Textos de los botones
- Mostrar/ocultar sidebar de resumen

---

## 📱 Experiencia del usuario

### **Desktop:**
- Grid de productos con vista completa
- Sidebar fijo con resumen del pack
- Selección de variantes inline
- Visualización de precios en tiempo real

### **Móvil:**
- **Carrusel horizontal** con scroll suave
- **Botón flotante** para ver el resumen
- **Modal de variantes** para selección fácil
- **Dots de navegación** para indicar posición

---

## 🎨 Personalización adicional

### **Cambiar el título del header**
Configura **"Título de la página"** en el personalizador.

### **Cambiar la URL**
Configura **"URL de la página"** en el personalizador (debe coincidir con la URL de la página en Tiendanube).

### **Deshabilitar temporalmente**
Desactiva el checkbox **"Habilitar página de Compra por Pasos"** en el personalizador.

---

## ❓ Preguntas frecuentes

**¿Puedo tener la sección en el home Y en la página dedicada?**
Sí, ambas pueden coexistir. La página dedicada usa la misma configuración.

**¿Cómo oculto la sección del home?**
Ve a **"Ordenar secciones del Home"** y desmarca **"Compra por Pasos (Codefy)"**.

**¿Puedo cambiar los tags de los productos?**
Sí, en **"Compra por Pasos (Codefy)"** puedes configurar los tags para cada paso en cada idioma.

**¿La página respeta los permisos de acceso?**
Sí, si marcas la página como "No visible" en Tiendanube, no aparecerá en el menú, pero seguirá siendo accesible por URL directa.

---

## 🐛 Troubleshooting

**Los productos no aparecen:**
- Verifica que los productos tengan el tag correcto
- Revisa que los tags en el personalizador coincidan con los del producto
- Asegúrate de que los productos tengan stock

**La página muestra error 404:**
- Verifica que la página esté creada en Tiendanube
- Asegúrate de que la URL en la página coincida con la del personalizador

**La página muestra contenido normal (no la sección):**
- Verifica que la URL en el admin coincida EXACTAMENTE con la del personalizador
- Asegúrate de haber subido el archivo `templates/page.tpl` actualizado
- Limpia la caché del navegador
- Revisa que el campo "URL de la página" en el personalizador tenga un valor

**El carrusel móvil no funciona:**
- Limpia la caché del navegador
- Verifica que el JavaScript se esté cargando correctamente

---

## 📞 Soporte

Para más ayuda o customizaciones adicionales, contacta al equipo de Codefy.

---

**¡Disfruta de tu nueva página de Compra por Pasos!** 🎉

