# Evaluación Sumativa Individual - Programación Móvil

**Estudiante:** Jhandry David Becerra Lima  
**Variante:** B  
**Proyecto:** Lugares UIDE - App de registro de lugares con geolocalización

## Descripción
Aplicación Flutter que permite registrar lugares con nombre, descripción y coordenadas GPS. Incluye funcionalidad de favoritos y seguimiento de ubicación en tiempo real.

## Correcciones realizadas

### 🐛 Bug corregido (TODO diagnóstico)
**Archivo:** `lib/screens/ubicacion_screen.dart` - método `dispose()`

**Problema:** Al salir de la pantalla "Mi ubicación", el `StreamSubscription` del GPS no se cancelaba, causando un memory leak. El stream seguía activo en segundo plano (los prints seguían apareciendo en consola).

**Solución:** Se agregó `_subscription?.cancel()` en el método `dispose()` para detener el stream de ubicación al salir de la pantalla.

### ✨ Feature nuevo (TODO feature)
**Archivo:** `lib/screens/ubicacion_screen.dart` - método `build()`

**Funcionalidad:** Se implementó el cálculo de distancia entre la posición actual del usuario y el campus UIDE Loja usando `Geolocator.distanceBetween()`. Si la distancia es menor a 500 metros, muestra un ícono verde con el mensaje "Estás cerca del campus UIDE". Si está más lejos, muestra la distancia en kilómetros con un ícono naranja.

## Cómo ejecutar
```bash
flutter create .
flutter pub get
flutter run
```
