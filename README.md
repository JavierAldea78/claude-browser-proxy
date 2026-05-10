# Claude Browser — app de escritorio via tunel seguro

Accede a Claude desde Windows con un doble-click, sin instalar nada especial
y sin que el trafico pase por tu red corporativa.

## Arquitectura

```
[launch-claude.bat]  →  HTTPS  →  [Fly.io: Chromium + noVNC]  →  claude.ai
   Windows                           contenedor 24/7
```

El contenedor corre en la nube (Madrid), siempre encendido, con Chromium
apuntando a claude.ai. Tu sesion (login de Claude) se guarda en un volumen
persistente — no tienes que volver a hacer login tras reinicios.

---

## Despliegue del contenedor (una sola vez)

### 1. Instala flyctl

```
https://fly.io/docs/hands-on/install-flyctl/
```

### 2. Lanza el contenedor

```bash
cd fly/
fly auth login
fly apps create claude-browser-javier --org personal
fly volumes create claude_data --size 1 --region mad
fly secrets set ACCESS_PASS=pon_aqui_tu_contrasena_segura
fly deploy
```

### 3. Comprueba que funciona

```bash
fly status
fly logs
```

Abre: `https://claude-browser-javier.fly.dev/vnc.html?autoconnect=true&resize=scale`

---

## Configurar el lanzador Windows

Edita `launcher/launch-claude.bat` y cambia:

```bat
set APP_URL=https://claude:TU_CONTRASENA@claude-browser-javier.fly.dev/vnc.html?autoconnect=true&resize=scale
```

Pon el `.bat` en el Escritorio (o en el Inicio) y dale icono personalizado
haciendo clic derecho → Propiedades → Cambiar icono.

---

## Seguridad

| Capa | Mecanismo |
|---|---|
| Transporte | HTTPS (TLS de Fly.io, certificado automatico) |
| Acceso | HTTP Basic Auth (usuario: `claude`, contrasena tuya) |
| Red VNC | x11vnc solo escucha en localhost dentro del contenedor |
| Sesion Claude | Cookies en volumen cifrado en el contenedor |
| Chromium | Perfil dedicado, sin extensiones, flags de hardening |

---

## Costes estimados

| Recurso | Coste |
|---|---|
| VM shared-cpu-1x 1GB | ~$5-7/mes |
| Volumen 1GB | ~$0.15/mes |
| Trafico saliente | incluido (160GB/mes gratis) |

---

## Alternativa: Codespace (sin coste, pero manual)

Ver `.devcontainer/` para la configuracion de GitHub Codespaces.
Util como fallback si el contenedor Fly.io esta caido.
