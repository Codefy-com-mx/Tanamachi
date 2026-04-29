<style>
.header-clock-container {
    font-family: 'Public Sans', Arial, Helvetica, sans-serif;
    font-weight: 800;
    font-size: 1.1rem !important;
    margin-right: 15px; /* Espacio entre el reloj y la lupa */
    line-height: 1;
    display: flex;
    align-items: center;
    color: inherit;
    margin-top: 0;
}
</style>

<span class="header-clock-container d-none d-md-flex" id="js-header-clock">
    00:00
</span>

<script>
document.addEventListener("DOMContentLoaded", function() {
    function updateHeaderClock() {
        var now = new Date();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        
        // Formatear minutos con cero inicial si es menor a 10
        if (minutes < 10) {
            minutes = "0" + minutes;
        }
        
        // Formato 24 horas o 12 horas. Según la referencia de un reloj de alarma, 
        // a veces usan 24hrs. Dejaremos 24hrs pero puedes ajustarlo.
        if (hours < 10) {
            hours = "0" + hours;
        }
        
        var timeString = hours + ":" + minutes;
        
        var clockElement = document.getElementById('js-header-clock');
        if (clockElement) {
            clockElement.innerText = timeString;
        }
    }
    
    // Actualizar inmediatamente y luego cada segundo para parpadeo de dos puntos si quisieras, 
    // pero cada minuto está bien. Lo dejaremos en 1 segundo para ser exactos.
    updateHeaderClock();
    setInterval(updateHeaderClock, 1000);
});
</script>
