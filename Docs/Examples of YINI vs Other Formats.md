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

# Like Python, structure relies entirely on indentation — easy to misread or misplace.
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

---

**^YINI ≡**  
> A simple, structured, and human-friendly configuration format.  

[yini-lang.org](https://yini-lang.org/?utm_source=github&utm_medium=referral&utm_campaign=yini_spec&utm_content=doc_footer) · [YINI on GitHub](https://github.com/YINI-lang)  
