# binance-proxy
binance-proxy docker build from [adrianceding/binance-proxy](https://github.com/adrianceding/binance-proxy) release with latest `GO` and run with latest `Alpine Linux`

#### run
```bash
docker run -d -p 8090:8090 -p 8091:8091 --restart always zercle/binance-proxy
```

### freqtrade config
```json
"exchange": {
        "name": "binance",
        "key": "",
        "secret": "",
        "ccxt_config": {
            "enableRateLimit": false,
            "timeout": 60000,
            "urls": {
                "api": {
                    "public": "http://127.0.01:8090/api/v3", # spot add this 
                    "fapiPublic": "http://127.0.01:8091/fapi/v1" # futures add this
                }
            }
        },
        "ccxt_async_config": {
            "enableRateLimit": false,
            "timeout": 60000
        },
}
```
