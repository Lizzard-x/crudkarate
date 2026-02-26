function fn() {
    var config = {
        baseUrl: karate.properties['baseUrl'] || 'https://simple-books-api.glitch.me'
    };

    // ✅ Esto hace que el HTML tenga request/response visible
    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);

    // ✅ Para que siga redirects (tu API responde 308 y redirige)
    karate.configure('followRedirects', true);

    return config;
}