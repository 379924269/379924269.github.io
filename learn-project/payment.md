# 💰 支付集成指南

## 📚 参考资料

- [支付宝开放平台](https://open.alipay.com/)
- [微信支付开放平台](https://pay.weixin.qq.com/)
- [支付宝 Java SDK](https://github.com/alipay/alipay-sdk-java-all)
- [微信支付 Java SDK](https://github.com/wechatpay-apiv3/wechatpay-java)

---

## 📑 目录

- [支付方式对比](#支付方式对比)
- [支付宝集成](#支付宝集成)
- [微信支付集成](#微信支付集成)
- [支付流程设计](#支付流程设计)
- [安全注意事项](#安全注意事项)
- [常见问题](#常见问题)

---

## 💳 支付方式对比

| 支付方式 | 适用场景 | 优势 | 劣势 |
|---------|---------|------|------|
| **支付宝** | 电商、B2C、B2B | 用户体验好、接口完善、文档清晰 | 手续费相对较高 |
| **微信支付** | 社交电商、小程序 | 用户基数大、社交传播强 | 开发门槛较高 |
| **银联支付** | 传统企业、B2B | 覆盖面广、安全性高 | 用户体验一般 |
| **余额支付** | 平台内部 | 成本低、可控性强 | 需要资金池资质 |

---

## 🅰️ 支付宝集成

### 一、准备工作

#### 1. 注册开发者账号

```
访问 https://open.alipay.com/
→ 注册开发者账号
→ 创建应用
→ 获取 AppID
```

#### 2. 配置密钥

```
生成应用公钥/私钥
→ 上传公钥到支付宝开放平台
→ 下载支付宝公钥
→ 配置 RSA2 签名方式
```

#### 3. 添加功能

```
电脑网站支付
手机网站支付
当面付
APP支付
```

---

### 二、Maven 依赖

```xml
<dependency>
    <groupId>com.alipay.sdk</groupId>
    <artifactId>alipay-sdk-java</artifactId>
    <version>4.38.61.ALL</version>
</dependency>
```

---

### 三、配置类

```java
@Configuration
public class AlipayConfig {
    
    @Value("${alipay.app-id}")
    private String appId;
    
    @Value("${alipay.private-key}")
    private String privateKey;
    
    @Value("${alipay.public-key}")
    private String publicKey;
    
    @Value("${alipay.gateway-url}")
    private String gatewayUrl;
    
    @Value("${alipay.notify-url}")
    private String notifyUrl;
    
    @Value("${alipay.return-url}")
    private String returnUrl;
    
    @Bean
    public AlipayClient alipayClient() {
        return new DefaultAlipayClient(
            gatewayUrl,
            appId,
            privateKey,
            "json",
            "UTF-8",
            publicKey,
            "RSA2"
        );
    }
}
```

---

### 四、支付接口实现

#### 1. 电脑网站支付

```java
@Service
public class AlipayService {
    
    @Autowired
    private AlipayClient alipayClient;
    
    @Value("${alipay.notify-url}")
    private String notifyUrl;
    
    @Value("${alipay.return-url}")
    private String returnUrl;
    
    public String createPagePay(String orderNo, BigDecimal amount, String subject) {
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        
        request.setNotifyUrl(notifyUrl);
        request.setReturnUrl(returnUrl);
        
        JSONObject bizContent = new JSONObject();
        bizContent.put("out_trade_no", orderNo);
        bizContent.put("total_amount", amount.toString());
        bizContent.put("subject", subject);
        bizContent.put("product_code", "FAST_INSTANT_TRADE_PAY");
        
        request.setBizContent(bizContent.toString());
        
        try {
            AlipayTradePagePayResponse response = alipayClient.pageExecute(request);
            return response.getBody();
        } catch (AlipayApiException e) {
            throw new RuntimeException("支付宝支付失败", e);
        }
    }
}
```

#### 2. 手机网站支付

```java
public String createWapPay(String orderNo, BigDecimal amount, String subject) {
    AlipayTradeWapPayRequest request = new AlipayTradeWapPayRequest();
    
    request.setNotifyUrl(notifyUrl);
    request.setReturnUrl(returnUrl);
    
    JSONObject bizContent = new JSONObject();
    bizContent.put("out_trade_no", orderNo);
    bizContent.put("total_amount", amount.toString());
    bizContent.put("subject", subject);
    bizContent.put("product_code", "QUICK_WAP_WAY");
    
    request.setBizContent(bizContent.toString());
    
    try {
        AlipayTradeWapPayResponse response = alipayClient.pageExecute(request);
        return response.getBody();
    } catch (AlipayApiException e) {
        throw new RuntimeException("支付宝WAP支付失败", e);
    }
}
```

---

### 五、异步通知处理

```java
@RestController
@RequestMapping("/api/alipay")
public class AlipayNotifyController {
    
    @Autowired
    private OrderService orderService;
    
    @PostMapping("/notify")
    public String alipayNotify(HttpServletRequest request) {
        Map<String, String> params = new HashMap<>();
        Map<String, String[]> requestParams = request.getParameterMap();
        
        for (String name : requestParams.keySet()) {
            String[] values = requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i] : valueStr + values[i] + ",";
            }
            params.put(name, valueStr);
        }
        
        String tradeNo = params.get("out_trade_no");
        String tradeStatus = params.get("trade_status");
        String totalAmount = params.get("total_amount");
        
        if ("TRADE_SUCCESS".equals(tradeStatus) || "TRADE_FINISHED".equals(tradeStatus)) {
            orderService.updateOrderStatus(tradeNo, "PAID", new BigDecimal(totalAmount));
        }
        
        return "success";
    }
}
```

---

### 六、查询订单

```java
public AlipayTradeQueryResponse queryOrder(String orderNo) {
    AlipayTradeQueryRequest request = new AlipayTradeQueryRequest();
    
    JSONObject bizContent = new JSONObject();
    bizContent.put("out_trade_no", orderNo);
    
    request.setBizContent(bizContent.toString());
    
    try {
        return alipayClient.execute(request);
    } catch (AlipayApiException e) {
        throw new RuntimeException("查询支付宝订单失败", e);
    }
}
```

---

### 七、退款接口

```java
public AlipayTradeRefundResponse refund(String orderNo, String refundAmount, String refundReason) {
    AlipayTradeRefundRequest request = new AlipayTradeRefundRequest();
    
    JSONObject bizContent = new JSONObject();
    bizContent.put("out_trade_no", orderNo);
    bizContent.put("refund_amount", refundAmount);
    bizContent.put("refund_reason", refundReason);
    
    request.setBizContent(bizContent.toString());
    
    try {
        return alipayClient.execute(request);
    } catch (AlipayApiException e) {
        throw new RuntimeException("支付宝退款失败", e);
    }
}
```

---

## 🅱️ 微信支付集成

### 一、准备工作

#### 1. 注册商户号

```
访问 https://pay.weixin.qq.com/
→ 注册商户号
→ 获取商户号 (mch_id)
→ 获取 AppID
```

#### 2. 配置 API 密钥

```
登录商户平台
→ 账户中心 → API安全
→ 设置 API 密钥
→ 下载证书
```

#### 3. 配置回调地址

```
产品中心 → 开发配置
→ 设置支付回调 URL
→ 设置退款回调 URL
```

---

### 二、Maven 依赖

```xml
<dependency>
    <groupId>com.github.wechatpay-apiv3</groupId>
    <artifactId>wechatpay-java</artifactId>
    <version>0.2.12</version>
</dependency>
```

---

### 三、配置类

```java
@Configuration
public class WechatPayConfig {
    
    @Value("${wechatpay.appid}")
    private String appId;
    
    @Value("${wechatpay.mchid}")
    private String mchId;
    
    @Value("${wechatpay.api-v3-key}")
    private String apiV3Key;
    
    @Value("${wechatpay.private-key-path}")
    private String privateKeyPath;
    
    @Value("${wechatpay.serial-no}")
    private String serialNo;
    
    @Bean
    public RSAAutoCertificateConfig rsaAutoCertificateConfig() throws Exception {
        PrivateKey merchantPrivateKey = PemUtil.loadPrivateKey(
            new FileInputStream(privateKeyPath)
        );
        
        return new RSAAutoCertificateConfig.Builder()
            .merchantId(mchId)
            .privateKey(merchantPrivateKey)
            .merchantSerialNumber(serialNo)
            .apiV3Key(apiV3Key)
            .build();
    }
    
    @Bean
    public WechatPayHttpClient wechatPayHttpClient() throws Exception {
        return new WechatPayHttpClient.Builder()
            .config(rsaAutoCertificateConfig())
            .build();
    }
}
```

---

### 四、支付接口实现

#### 1. Native 支付（扫码支付）

```java
@Service
public class WechatPayService {
    
    @Autowired
    private WechatPayHttpClient wechatPayHttpClient;
    
    @Value("${wechatpay.notify-url}")
    private String notifyUrl;
    
    public String createNativePay(String orderNo, BigDecimal amount, String description) {
        NativePayRequest request = new NativePayRequest();
        
        Amount amountObj = new Amount();
        amountObj.setTotal(amount.multiply(new BigDecimal(100)).intValue());
        amountObj.setCurrency("CNY");
        
        request.setOutTradeNo(orderNo);
        request.setDescription(description);
        request.setNotifyUrl(notifyUrl);
        request.setAmount(amountObj);
        
        try {
            NativePayResponse response = wechatPayHttpClient.nativePay(request);
            return response.getCodeUrl();
        } catch (Exception e) {
            throw new RuntimeException("微信Native支付失败", e);
        }
    }
}
```

#### 2. H5 支付

```java
public String createH5Pay(String orderNo, BigDecimal amount, String description) {
    H5PayRequest request = new H5PayRequest();
    
    Amount amountObj = new Amount();
    amountObj.setTotal(amount.multiply(new BigDecimal(100)).intValue());
    amountObj.setCurrency("CNY");
    
    H5Info h5Info = new H5Info();
    h5Info.setType("Wap");
    
    request.setOutTradeNo(orderNo);
    request.setDescription(description);
    request.setNotifyUrl(notifyUrl);
    request.setAmount(amountObj);
    request.setH5Info(h5Info);
    
    try {
        H5PayResponse response = wechatPayHttpClient.h5Pay(request);
        return response.getH5Url();
    } catch (Exception e) {
        throw new RuntimeException("微信H5支付失败", e);
    }
}
```

---

### 五、异步通知处理

```java
@RestController
@RequestMapping("/api/wechatpay")
public class WechatPayNotifyController {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private RSAAutoCertificateConfig config;
    
    @PostMapping("/notify")
    public String wechatPayNotify(HttpServletRequest request) throws Exception {
        String body = StreamUtils.copyToString(request.getInputStream(), StandardCharsets.UTF_8);
        
        NotificationRequest notificationRequest = new NotificationRequest.Builder()
            .serialNumber(request.getHeader("Wechatpay-Serial"))
            .nonce(request.getHeader("Wechatpay-Nonce"))
            .signature(request.getHeader("Wechatpay-Signature"))
            .timestamp(request.getHeader("Wechatpay-Timestamp"))
            .body(body)
            .build();
        
        Notification notification = new Notification.Builder()
            .withConfig(config)
            .build()
            .parse(notificationRequest);
        
        String decryptData = notification.decryptResource();
        
        JSONObject data = JSON.parseObject(decryptData);
        String orderNo = data.getString("out_trade_no");
        String tradeStatus = data.getString("trade_state");
        BigDecimal amount = data.getBigDecimal("amount").getJSONObject("payer_total").divide(new BigDecimal(100));
        
        if ("SUCCESS".equals(tradeStatus)) {
            orderService.updateOrderStatus(orderNo, "PAID", amount);
        }
        
        return "{\"code\":\"SUCCESS\",\"message\":\"成功\"}";
    }
}
```

---

### 六、查询订单

```java
public Transaction queryOrder(String orderNo) {
    GetPayTransactionByNoRequest request = new GetPayTransactionByNoRequest();
    request.setOutTradeNo(orderNo);
    request.setMchid(mchId);
    
    try {
        return wechatPayHttpClient.queryOrder(request);
    } catch (Exception e) {
        throw new RuntimeException("查询微信订单失败", e);
    }
}
```

---

### 七、退款接口

```java
public Refund createRefund(String orderNo, String refundNo, BigDecimal amount, String reason) {
    CreateRefundRequest request = new CreateRefundRequest();
    
    AmountReq amountReq = new AmountReq();
    amountReq.setRefund(amount.multiply(new BigDecimal(100)).intValue());
    amountReq.setTotal(amount.multiply(new BigDecimal(100)).intValue());
    amountReq.setCurrency("CNY");
    
    request.setOutTradeNo(orderNo);
    request.setOutRefundNo(refundNo);
    request.setReason(reason);
    request.setNotifyUrl(refundNotifyUrl);
    request.setAmount(amountReq);
    
    try {
        return wechatPayHttpClient.createRefund(request);
    } catch (Exception e) {
        throw new RuntimeException("微信退款失败", e);
    }
}
```

---

## 🔄 支付流程设计

### 一、支付状态机

```
待支付 (PENDING)
    ↓
支付中 (PAYING)
    ↓
已支付 (PAID) ←→ 退款中 (REFUNDING) → 已退款 (REFUNDED)
    ↓
支付失败 (FAILED)
    ↓
已取消 (CANCELLED)
```

---

### 二、支付流程图

```
用户下单
    ↓
生成订单号
    ↓
调用支付接口
    ↓
返回支付页面/二维码
    ↓
用户完成支付
    ↓
支付平台异步通知
    ↓
更新订单状态
    ↓
发送通知给用户
```

---

### 三、订单超时取消

```java
@Service
public class OrderTimeoutService {
    
    @Autowired
    private RabbitTemplate rabbitTemplate;
    
    @Autowired
    private OrderService orderService;
    
    public void createOrder(Order order) {
        orderService.save(order);
        
        rabbitTemplate.convertAndSend(
            "order.exchange",
            "order.timeout",
            order.getOrderNo(),
            message -> {
                message.getMessageProperties().setExpiration("1800000");
                return message;
            }
        );
    }
    
    @RabbitListener(queues = "order.timeout.queue")
    public void handleTimeout(String orderNo) {
        Order order = orderService.getByOrderNo(orderNo);
        if (order != null && "PENDING".equals(order.getStatus())) {
            orderService.updateStatus(orderNo, "CANCELLED");
        }
    }
}
```

---

### 四、支付幂等性设计

```java
@Service
public class PaymentService {
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    
    @Transactional
    public void processPayment(String orderNo, BigDecimal amount) {
        String lockKey = "payment:lock:" + orderNo;
        
        Boolean locked = redisTemplate.opsForValue().setIfAbsent(
            lockKey, 
            "1", 
            30, 
            TimeUnit.SECONDS
        );
        
        if (!locked) {
            throw new RuntimeException("订单正在处理中");
        }
        
        try {
            Order order = orderService.getByOrderNo(orderNo);
            
            if ("PAID".equals(order.getStatus())) {
                return;
            }
            
            orderService.updateStatus(orderNo, "PAID");
            orderService.updateAmount(orderNo, amount);
            
        } finally {
            redisTemplate.delete(lockKey);
        }
    }
}
```

---

## 🔒 安全注意事项

### 一、签名验证

```java
public boolean verifyAlipayNotify(Map<String, String> params) {
    String sign = params.get("sign");
    String signType = params.get("sign_type");
    
    params.remove("sign");
    params.remove("sign_type");
    
    String content = AlipaySignature.getSignCheckContentV1(params);
    
    try {
        return AlipaySignature.rsa256CheckContent(
            content, 
            sign, 
            publicKey, 
            "UTF-8"
        );
    } catch (AlipayApiException e) {
        return false;
    }
}
```

---

### 二、数据加密

```java
public String encryptData(String data) {
    try {
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encrypted = cipher.doFinal(data.getBytes());
        return Base64.getEncoder().encodeToString(encrypted);
    } catch (Exception e) {
        throw new RuntimeException("数据加密失败", e);
    }
}
```

---

### 三、防重放攻击

```java
public boolean checkReplayAttack(String nonce, String timestamp) {
    String key = "payment:nonce:" + nonce;
    
    String exists = redisTemplate.opsForValue().get(key);
    if (exists != null) {
        return false;
    }
    
    long requestTime = Long.parseLong(timestamp);
    long currentTime = System.currentTimeMillis();
    
    if (Math.abs(currentTime - requestTime) > 300000) {
        return false;
    }
    
    redisTemplate.opsForValue().set(key, "1", 5, TimeUnit.MINUTES);
    
    return true;
}
```

---

### 四、敏感信息保护

```java
public String maskCardNo(String cardNo) {
    if (cardNo == null || cardNo.length() < 10) {
        return cardNo;
    }
    return cardNo.substring(0, 6) + "******" + cardNo.substring(cardNo.length() - 4);
}

public String maskPhone(String phone) {
    if (phone == null || phone.length() < 7) {
        return phone;
    }
    return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
}
```

---

## ❓ 常见问题

### 一、支付失败常见原因

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 签名错误 | 密钥配置错误 | 检查公私钥配置 |
| 金额错误 | 金额格式不正确 | 使用字符串格式，保留两位小数 |
| 回调失败 | 回调地址不可访问 | 检查服务器防火墙和网络配置 |
| 订单不存在 | 订单号重复 | 使用唯一订单号生成策略 |

---

### 二、退款问题

| 问题 | 原因 | 解决方案 |
|------|------|---------|
| 退款失败 | 订单未支付 | 检查订单状态 |
| 退款超时 | 银行处理中 | 设置合理的退款超时时间 |
| 部分退款 | 金额超过可退金额 | 检查退款金额限制 |

---

### 三、对账问题

```java
@Service
public class ReconciliationService {
    
    public void reconcile(LocalDate date) {
        List<Order> orders = orderService.getOrdersByDate(date);
        
        for (Order order : orders) {
            if ("PAID".equals(order.getStatus())) {
                boolean verified = verifyWithPaymentPlatform(order);
                if (!verified) {
                    log.warn("订单对账失败: {}", order.getOrderNo());
                }
            }
        }
    }
    
    private boolean verifyWithPaymentPlatform(Order order) {
        if ("ALIPAY".equals(order.getPaymentType())) {
            AlipayTradeQueryResponse response = alipayService.queryOrder(order.getOrderNo());
            return "TRADE_SUCCESS".equals(response.getTradeStatus());
        } else if ("WECHAT".equals(order.getPaymentType())) {
            Transaction transaction = wechatPayService.queryOrder(order.getOrderNo());
            return "SUCCESS".equals(transaction.getTradeState());
        }
        return false;
    }
}
```

---

## 📊 最佳实践

### 一、支付配置管理

```yaml
alipay:
  app-id: ${ALIPAY_APP_ID}
  private-key: ${ALIPAY_PRIVATE_KEY}
  public-key: ${ALIPAY_PUBLIC_KEY}
  gateway-url: https://openapi.alipay.com/gateway.do
  notify-url: ${SERVER_URL}/api/alipay/notify
  return-url: ${SERVER_URL}/api/alipay/return

wechatpay:
  appid: ${WECHATPAY_APP_ID}
  mchid: ${WECHATPAY_MCH_ID}
  api-v3-key: ${WECHATPAY_API_V3_KEY}
  private-key-path: ${WECHATPAY_PRIVATE_KEY_PATH}
  serial-no: ${WECHATPAY_SERIAL_NO}
  notify-url: ${SERVER_URL}/api/wechatpay/notify
  refund-notify-url: ${SERVER_URL}/api/wechatpay/refund/notify
```

---

### 二、日志记录

```java
@Aspect
@Component
public class PaymentLogAspect {
    
    @Around("@annotation(PaymentLog)")
    public Object logPayment(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().getName();
        Object[] args = joinPoint.getArgs();
        
        log.info("支付请求开始: 方法={}, 参数={}", methodName, JSON.toJSONString(args));
        
        long startTime = System.currentTimeMillis();
        Object result;
        
        try {
            result = joinPoint.proceed();
            long endTime = System.currentTimeMillis();
            log.info("支付请求成功: 方法={}, 耗时={}ms, 结果={}", 
                methodName, endTime - startTime, JSON.toJSONString(result));
            return result;
        } catch (Exception e) {
            long endTime = System.currentTimeMillis();
            log.error("支付请求失败: 方法={}, 耗时={}ms, 异常={}", 
                methodName, endTime - startTime, e.getMessage(), e);
            throw e;
        }
    }
}
```

---

### 三、监控告警

```java
@Service
public class PaymentMonitorService {
    
    @Autowired
    private MeterRegistry meterRegistry;
    
    public void recordPayment(String paymentType, boolean success) {
        Counter.builder("payment.requests")
            .tag("type", paymentType)
            .tag("status", success ? "success" : "failed")
            .register(meterRegistry)
            .increment();
    }
    
    public void recordPaymentTime(String paymentType, long duration) {
        Timer.builder("payment.duration")
            .tag("type", paymentType)
            .register(meterRegistry)
            .record(duration, TimeUnit.MILLISECONDS);
    }
}
```

---

## 🎯 总结

支付集成是电商系统的核心功能，需要注意以下几点：

1. **安全性**：严格验证签名，防止数据篡改
2. **可靠性**：实现幂等性，防止重复支付
3. **可维护性**：完善的日志和监控，便于问题排查
4. **扩展性**：支持多种支付方式，便于业务扩展

通过以上实践，可以构建一个稳定、安全、可靠的支付系统。