# Examples of YINI vs Other Formats 
YINI is intended for configuration files where human readability, explicit structure, and predictable parsing are more important than minimal syntax or maximum flexibility.

Compared with common configuration formats:
- **INI:** YINI supports clearer nested sections and typed values.
- **JSON:** YINI supports comments and is easier to edit by hand.
- **YAML:** YINI does not use indentation to define structure.
- **TOML:** YINI uses explicit section markers for hierarchy instead of dotted table names.

The same small configuration can be written in several formats:

### YINI
```ini
^ Application
name = 'demo'
environment = 'dev'

^^ Server
host = 'localhost'
ports = [8080, 8081]

^^^ TLS
enabled = true
mode = 'optional'
```

- `Application` contains the top-level application settings.
- `Server` is nested under `Application`.
- `TLS` is nested under `Server`.
- The section markers `^` make the nesting explicit. Indentation is optional and not required for structure.
- Strings can use either `'` or `"`.

### JSON
```json
{
  "Application": {
    "name": "demo",
    "environment": "dev",
    "Server": {
      "host": "localhost",
      "ports": [8080, 8081],
      "TLS": {
        "enabled": true,
        "mode": "optional"
      }
    }
  }
}
```

### YAML
```yaml
Application:
  name: demo
  environment: dev
  Server:
    host: localhost
    ports:
      - 8080
      - 8081
    TLS:
      enabled: true
      mode: optional
```

### TOML
```toml
[Application]
name = "demo"
environment = "dev"

[Application.Server]
host = "localhost"
ports = [8080, 8081]

[Application.Server.TLS]
enabled = true
mode = "optional"
```

---

**^YINI ≡**  
> A simple, structured, and human-friendly configuration format.  

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=doc_footer) · [YINI-lang on GitHub](https://github.com/YINI-lang)  
