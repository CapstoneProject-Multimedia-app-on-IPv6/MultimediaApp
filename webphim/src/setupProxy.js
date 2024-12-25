const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function (app) {
    app.use(
        '/Api',
        createProxyMiddleware({
            target: 'http://10.0.1.2:8089',
            changeOrigin: true,
        }),
    );
};
