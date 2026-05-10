# Claude Browser via Codespaces

Accede a Claude desde cualquier navegador sin instalar nada en tu portátil.

## Cómo funciona

```
Tu navegador → Codespace (GitHub) → Chromium virtual → claude.ai
```

Se usa **noVNC** para transmitir un Chromium real corriendo en el Codespace directamente a tu navegador, todo autenticado por GitHub.

## Usar

1. Abre este repo en GitHub y haz clic en **Code → Open in Codespace**
2. Espera ~2 min la primera vez (construye la imagen con Chromium pre-instalado)
3. El puerto 6080 se reenvía automáticamente y abre Claude en tu navegador
4. Si no se abre solo, ve al panel de puertos y haz clic en el enlace del puerto 6080

## URL recomendada

```
https://<tu-codespace>-6080.preview.app.github.dev/vnc.html?autoconnect=true&resize=scale
```

## Seguridad

- El acceso al puerto 6080 requiere autenticacion de GitHub — nadie externo puede entrar
- La sesion VNC tiene contrasena aleatoria generada en cada contenedor nuevo
- Chromium guarda la sesion de Claude en el contenedor (no en tu maquina local)
- Si el contenedor se elimina, la sesion de Claude se pierde (vuelve a hacer login)

## Estabilidad

- Chromium se reinicia automaticamente si se cuelga o cierra inesperadamente
- Los logs de Chromium estan en `/tmp/chromium.log` dentro del Codespace
- Para ver la contrasena VNC: `cat ~/.vnc-password` en la terminal del Codespace

## Rebuilds

Los rebuilds son mas rapidos porque Chromium esta pre-instalado en la imagen Docker.
Solo la primera construccion tarda ~2 min; los reinicios normales arrancan en segundos.
