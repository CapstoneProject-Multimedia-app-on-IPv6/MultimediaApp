const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function (app) {
    app.use(
        '/Api',
        createProxyMiddleware({
            target: 'http://34.143.231.128:8089',
            changeOrigin: true,
        }),
    );
};
