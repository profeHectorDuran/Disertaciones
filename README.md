# AulaEval — Evaluación de disertaciones

Prototipo web responsive para docentes. Incluye:
- Rúbricas reutilizables con criterios y puntajes máximos.
- Registro de puntajes y observaciones por estudiante.
- Cálculo automático de nota chilena 1,0–7,0, con 60 % de exigencia predeterminada.
- Historial con filtros, edición y eliminación.
- Exportación CSV compatible con Excel (separador `;` y BOM UTF-8).
- Persistencia local de respaldo en el navegador.
- Integración opcional con Supabase para sincronizar el espacio de trabajo entre dispositivos.

## Ejecutar localmente

1. Descomprime el archivo.
2. Abre `index.html` en Chrome, Edge o Firefox.
3. La aplicación funciona en modo local para probar sus funciones. Los datos quedan guardados en ese navegador mediante `localStorage`.
4. Para datos de prueba, ve a **Configuración → Cargar datos de ejemplo**.

Para una publicación estática, también puedes subir `index.html` a GitHub Pages, Cloudflare Pages o un hosting HTTPS. No publiques datos reales de estudiantes en un repositorio público.

## Activar sincronización en línea con Supabase

1. Crea un proyecto en https://supabase.com/.
2. En **SQL Editor**, ejecuta el contenido de `supabase.sql`.
3. En **Authentication → Users**, crea un usuario para el docente. Usa una contraseña robusta y no compartas la cuenta.
4. En **Project Settings → API**, copia la Project URL y la clave pública `anon`/`publishable`.
5. Abre AulaEval → **Configuración**. Ingresa URL y clave pública, guarda y luego inicia sesión con el usuario docente.
6. En el primer inicio se carga el espacio remoto si existe; si no existe, se sube el estado local actual.
7. Para abrirlo en otro dispositivo, entra a la misma aplicación publicada, configura la misma URL/clave pública e inicia sesión con la misma cuenta.

### Importante
- La clave pública `anon`/`publishable` está diseñada para uso en el cliente junto con RLS. **Nunca** uses `service_role` o una clave secreta en el navegador.
- La tabla y las políticas RLS restringen el acceso al registro del usuario autenticado.
- La sincronización se realiza al guardar, editar o eliminar datos; este prototipo no implementa sincronización en tiempo real entre pestañas/dispositivos.
- Los cambios locales no se suben hasta iniciar sesión. Al iniciar sesión, si ya existe un espacio remoto, este reemplaza el estado local; respalda CSV antes de cambiar de equipo o usuario.
- Para uso institucional con datos reales, revisa las políticas de privacidad, respaldo y retención de datos de tu establecimiento.

## Modelo de cálculo de notas

Sea `p = puntaje_obtenido / puntaje_máximo × 100` y `e` la exigencia (%):
- Si `p < e`: `nota = 1 + (p/e) × 2,9`
- Si `p >= e`: `nota = 4 + ((p-e)/(100-e)) × 3`
- Se limita al intervalo 1,0–7,0 y se redondea a un decimal.
- El porcentaje de exigencia se puede escoger para cada evaluación (por defecto 60 %).

Ejemplos de prueba incluidos en el código (se muestran en la consola del navegador):
- 0/20 con 60 % → 1,0
- 12/20 con 60 % → 4,0
- 20/20 con 60 % → 7,0
- 10/20 con 50 % → 4,0
- 6/20 con 60 % → 2,5
- 25/20 con 60 % → limitado a 7,0

## Archivos
- `index.html`: aplicación.
- `supabase.sql`: tabla y políticas de acceso.
- `README.md`: guía de instalación y configuración.
