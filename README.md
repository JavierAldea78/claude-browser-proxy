# Claude Browser via Codespaces

Accede a Claude desde cualquier navegador sin instalar nada en tu portátil.

## Cómo funciona

```
Tu navegador → Codespace (GitHub) → Chromium virtual → claude.ai
```

Se usa **noVNC** para transmitir un Chromium real corriendo en el Codespace directamente a tu navegador, todo autenticado por GitHub.

## Usar

1. Abre este repo en GitHub y haz clic en **Code → Open in Codespace**
2. Espera ~1 min a que arranque el contenedor
3. El puerto 6080 se reenvía automáticamente y abre Claude en tu navegador
4. Si no se abre solo, ve al panel de puertos y haz clic en el enlace del puerto 6080

## Añadir al URL para mejor experiencia

```
?autoconnect=true&resize=scale
```

Ejemplo:
```
https://<tu-codespace>-6080.preview.app.github.dev/vnc.html?autoconnect=true&resize=scale
```
