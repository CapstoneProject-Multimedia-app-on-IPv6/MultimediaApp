const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function (app) {
    app.use(
        '/Api',
        createProxyMiddleware({
            target: 'http://35.240.202.89:80/api',
            changeOrigin: true,
        }),
    );
};
