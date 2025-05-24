# Examples of YINI vs Other Formats 
*(--TODO--)*

## INI vs YINI
### Before (INI)
```ini
[Server]                # Defines a section named Server.
host=localhost
port=8080

[Features]              # Defines a section named Features.
login=true
notifications=false
```

### After (YINI)
```js
^ Server                // Defines a section named Server.
host = "localhost"
port = 8080

^ Features              // Defines a section named Features.
login = true
notifications = false
```

## YAML vs YINI
### Before (YAML)
```
server:
    connection:
        host: "localhost"
        port: 8080  # Dev port
    auth:
        enabled: true
        credentials:
            username: "admin"
            password: "secret"  # Change me!

# This config is indented. Like, really indented.
```

### After (YINI)
```yini
^ server

    ^^ connection
    host = "localhost"
    port = 8080  // Dev port

    ^^ auth
    enabled = true

        ^^^ credentials
        username = "admin"
        password = "secret"  // Change me!

; This config stays pretty clean and easy to read.
```
