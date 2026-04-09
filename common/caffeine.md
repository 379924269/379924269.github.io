Caffeine Cache 的使用教程。Caffeine 是 Guava Cache 的高性能替代品，Spring Boot 默认集成的缓存库。

## 📚 Caffeine Cache 使用教程

### 一、Maven 依赖

在 ruoyi-vue-pro 项目中添加依赖：

```xml
<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
    <version>3.1.8</version>
</dependency>
```

**注意**：Spring Boot 已自动管理版本，通常不需要指定版本号。

---

### 二、基本使用示例

#### 1️⃣ **最简单的 Cache 创建**

```java
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;

public class SimpleCacheExample {
    
    public static void main(String[] args) {
        // 创建缓存
        Cache<String, Object> cache = Caffeine.newBuilder()
                .maximumSize(1000)  // 最大容量
                .build();
        
        // 存入数据
        cache.put("key1", "value1");
        cache.put("key2", "value2");
        
        // 获取数据
        Object value = cache.getIfPresent("key1");
        System.out.println(value);  // value1
        
        // 获取或计算（如果不存在则自动加载）
        Object value2 = cache.get("key3", k -> "computed-" + k);
        System.out.println(value2);  // computed-key3
        
        // 删除数据
        cache.invalidate("key1");
        
        // 批量删除
        cache.invalidateAll(List.of("key2", "key3"));
    }
}
```

---

#### 2️⃣ **带过期时间的 Cache**

```java
import java.time.Duration;
import java.util.concurrent.TimeUnit;

public class ExpiringCacheExample {
    
    public static void main(String[] args) throws InterruptedException {
        Cache<String, String> cache = Caffeine.newBuilder()
                // 写入后 5 分钟过期
                .expireAfterWrite(5, TimeUnit.MINUTES)
                // 访问后 5 分钟过期（与 expireAfterWrite 互斥）
                .expireAfterAccess(5, TimeUnit.MINUTES)
                // 初始容量
                .initialCapacity(10)
                // 最大容量
                .maximumSize(1000)
                .build();
        
        cache.put("user:1", "张三");
        
        // 5 分钟后再次获取，返回 null（已过期）
        Thread.sleep(5 * 60 * 1000);
        String user = cache.getIfPresent("user:1");
        System.out.println(user);  // null
    }
}
```

**更灵活的过期策略（Java 8+ Duration）：**

```java
Cache<String, String> cache = Caffeine.newBuilder()
        .expireAfterWrite(Duration.ofMinutes(10))
        .expireAfterAccess(Duration.ofMinutes(5))
        .build();
```

---

#### 3️⃣ **自动加载数据的 Cache（AsyncLoadingCache）**

```java
import com.github.benmanes.caffeine.cache.AsyncLoadingCache;

public class LoadingCacheExample {
    
    public static void main(String[] args) throws Exception {
        // 创建带自动加载功能的缓存
        AsyncLoadingCache<String, String> cache = Caffeine.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .buildAsync(key -> {
                    // 缓存未命中时，自动调用此方法加载数据
                    System.out.println("从数据库加载：" + key);
                    return loadDataFromDatabase(key);
                });
        
        // 异步获取数据
        CompletableFuture<String> future1 = cache.get("user:1");
        String value1 = future1.join();  // 阻塞等待结果
        System.out.println(value1);
        
        // 第二次获取，直接从缓存返回
        CompletableFuture<String> future2 = cache.get("user:1");
        String value2 = future2.join();
        System.out.println(value2);
        
    }
    
    private static String loadDataFromDatabase(String key) {
        // 模拟从数据库加载
        return "Data for " + key;
    }
}
```

**同步版本（LoadingCache）：**

```java
import com.github.benmanes.caffeine.cache.LoadingCache;

LoadingCache<String, String> cache = Caffeine.newBuilder()
        .maximumSize(1000)
        .expireAfterWrite(10, TimeUnit.MINUTES)
        .build(key -> loadDataFromDatabase(key));

// 同步获取
String value = cache.get("user:1");
```

---

#### 4️⃣ **带刷新功能的 Cache**

```java
import com.github.benmanes.caffeine.cache.CacheLoader;
import com.github.benmanes.caffeine.cache.LoadingCache;
import org.checkerframework.checker.nullness.qual.NonNull;
import org.checkerframework.checker.nullness.qual.Nullable;

public class RefreshCacheExample {
    
    public static void main(String[] args) throws Exception {
        LoadingCache<String, String> cache = Caffeine.newBuilder()
                .maximumSize(1000)
                // 写入后 10 分钟过期
                .expireAfterWrite(10, TimeUnit.MINUTES)
                // 写入后 5 分钟自动刷新
                .refreshAfterWrite(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, String>() {
                    @Override
                    public @Nullable String load(String key) throws Exception {
                        System.out.println("【load】加载数据：" + key);
                        return loadData(key);
                    }
                    
                    @Override
                    public @Nullable String reload(String key, @NonNull String oldValue) throws Exception {
                        // 刷新时的回调（同步）
                        System.out.println("【reload】刷新数据：" + key);
                        return loadData(key);
                    }
                });
        
        // 首次访问
        cache.get("config:1");
        
        // 5 分钟后再次访问，会触发刷新
        Thread.sleep(5 * 60 * 1000);
        cache.get("config:1");
    }
    
    private static String loadData(String key) {
        return "Updated data for " + key;
    }
}
```

---

#### 5️⃣ **基于统计的 Cache**

```java
import com.github.benmanes.caffeine.cache.CacheStats;

public class StatsCacheExample {
    
    public static void main(String[] args) {
        LoadingCache<String, String> cache = Caffeine.newBuilder()
                .maximumSize(1000)
                .recordStats()  // 开启统计
                .build(key -> loadData(key));
        
        // 访问缓存
        cache.get("key1");
        cache.get("key2");
        cache.get("key1");  // 命中缓存
        cache.get("key3");
        
        // 获取统计信息
        CacheStats stats = cache.stats();
        System.out.println("命中率：" + stats.hitRate());
        System.out.println("命中次数：" + stats.hitCount());
        System.out.println("未命中次数：" + stats.missCount());
        System.out.println("总请求数：" + stats.requestCount());
        System.out.println("加载次数：" + stats.loadCount());
        System.out.println("平均加载时间：" + stats.averageLoadPenalty() + "ms");
        
        // 打印所有统计
        System.out.println(stats.toString());
    }
    
    private static String loadData(String key) {
        return "Value for " + key;
    }
}
```

---

#### 6️⃣ **删除监听器**

```java
import com.github.benmanes.caffeine.cache.RemovalCause;
import com.github.benmanes.caffeine.cache.RemovalListener;

public class RemovalCacheExample {
    
    public static void main(String[] args) {
        Cache<String, String> cache = Caffeine.newBuilder()
                .maximumSize(100)
                // 监听删除事件
                .removalListener((key, value, cause) -> {
                    System.out.println("删除原因：" + cause);
                    System.out.println("Key: " + key);
                    System.out.println("Value: " + value);
                    
                    // 根据删除原因做不同处理
                    if (cause == RemovalCause.EXPIRED) {
                        System.out.println("数据已过期");
                    } else if (cause == RemovalCause.SIZE) {
                        System.out.println("超出容量限制");
                    } else if (cause == RemovalCause.EXPLICIT) {
                        System.out.println("手动删除");
                    }
                })
                .build();
        
        cache.put("key1", "value1");
        
        // 手动删除
        cache.invalidate("key1");
        
        // 清空所有
        cache.invalidateAll();
    }
}
```

**RemovalCause 枚举值：**

- `EXPLICIT`：用户手动删除
- `REPLACED`：被新值替换
- `COLLECTED`：被 GC 回收
- `EXPIRED`：过期
- `SIZE`：超出容量限制

---

### 三、高级特性

#### 1️⃣ **基于大小的淘汰策略**

```java
Cache<String, String> cache = Caffeine.newBuilder()
        // 方式 1：基于数量淘汰
        .maximumSize(10000)
        
        // 方式 2：基于权重淘汰（需要配合 weigher）
        .maximumWeight(100_000)
        .weigher((key, value) -> {
            // 根据值的大小计算权重
            String str = (String) value;
            return str.length();  // 字符串长度作为权重
        })
        
        .build();
```

---

#### 2️⃣ **自定义过期策略（精细控制）**

```java
import com.github.benmanes.caffeine.cache.Expiry;

public class CustomExpiryExample {
    
    public static void main(String[] args) {
        Cache<String, String> cache = Caffeine.newBuilder()
                .expireAfter(new Expiry<String, String>() {
                    @Override
                    public long expireAfterCreate(@NonNull String key, 
                                                  @NonNull String value, 
                                                  long currentTimeNanos) {
                        // 创建时计算过期时间（纳秒）
                        if (key.startsWith("vip")) {
                            return TimeUnit.MINUTES.toNanos(30);  // VIP 用户 30 分钟
                        }
                        return TimeUnit.MINUTES.toNanos(10);  // 普通用户 10 分钟
                    }
                    
                    @Override
                    public long expireAfterUpdate(@NonNull String key, 
                                                  @NonNull String value, 
                                                  long currentTimeNanos, 
                                                  long currentDurationNanos) {
                        // 更新时重新计算过期时间
                        return currentDurationNanos;  // 保持不变
                    }
                    
                    @Override
                    public long expireAfterRead(@NonNull String key, 
                                                @NonNull String value, 
                                                long currentTimeNanos, 
                                                long currentDurationNanos) {
                        // 读取时重新计算过期时间
                        return TimeUnit.MINUTES.toNanos(5);  // 读取后 5 分钟过期
                    }
                })
                .build();
    }
}
```

---

#### 3️⃣ **异步缓存（高性能）**

```java
import com.github.benmanes.caffeine.cache.AsyncLoadingCache;

public class AsyncCacheExample {
    
    public static void main(String[] args) {
        AsyncLoadingCache<String, String> cache = Caffeine.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .buildAsync(key -> {
                    // 异步加载数据
                    return CompletableFuture.supplyAsync(() -> {
                        System.out.println("异步加载：" + key);
                        try {
                            Thread.sleep(100);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                        return "Data: " + key;
                    });
                });
        
        // 非阻塞获取
        CompletableFuture<String> future = cache.get("key1");
        future.thenAccept(value -> 
            System.out.println("收到数据：" + value)
        );
        
        // 批量获取
        List<String> keys = List.of("key1", "key2", "key3");
        CompletableFuture<Map<String, String>> allFutures = cache.getAll(keys);
        allFutures.thenAccept(map -> 
            map.forEach((k, v) -> System.out.println(k + " = " + v))
        );
    }
}
```

---

### 四、Spring Boot 集成

#### 1️⃣ **添加 Spring Cache 依赖**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>

<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
</dependency>
```

---

#### 2️⃣ **配置类**

```java
import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
public class CacheConfig {
    
    @Bean
    public CacheManager cacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .initialCapacity(100)
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .recordStats());
        return cacheManager;
    }
    
    // 或者指定多个缓存区域
    @Bean
    public CacheManager customCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.registerCustomCache("users", Caffeine.newBuilder()
                .maximumSize(500)
                .expireAfterWrite(5, TimeUnit.MINUTES)
                .build());
        cacheManager.registerCustomCache("products", Caffeine.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .build());
        return cacheManager;
    }
}
```

---

#### 3️⃣ **使用 @Cacheable 注解**

```java
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    /**
     * 查询用户，自动缓存到 users 缓存区
     */
    @Cacheable(value = "users", key = "#userId")
    public UserDO getUserById(Long userId) {
        log.info("查询数据库：userId={}", userId);
        return userMapper.selectById(userId);
    }
    
    /**
     * 条件缓存
     */
    @Cacheable(value = "users", key = "#userId", condition = "#userId > 0")
    public UserDO getUserWithCondition(Long userId) {
        return userMapper.selectById(userId);
    }
    
    /**
     * 除非满足条件才缓存
     */
    @Cacheable(value = "users", key = "#userId", unless = "#result == null")
    public UserDO getUserUnlessNull(Long userId) {
        // 只有返回值不为 null 时才缓存
        return userMapper.selectById(userId);
    }
}
```

---

#### 4️⃣ **缓存更新和删除**

```java
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.CacheConfig;

@CacheConfig(cacheNames = "users")  // 公共缓存配置
@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    /**
     * 更新缓存（总是执行方法并更新缓存）
     */
    @CachePut(key = "#user.id")
    public UserDO updateUser(UserDO user) {
        userMapper.updateById(user);
        return user;
    }
    
    /**
     * 删除缓存
     */
    @CacheEvict(key = "#userId")
    public void deleteUser(Long userId) {
        userMapper.deleteById(userId);
    }
    
    /**
     * 删除所有缓存
     */
    @CacheEvict(allEntries = true)
    public void clearAllCache() {
        // 清除所有 users 缓存
    }
    
    /**
     * 方法执行前就清除缓存
     */
    @CacheEvict(key = "#userId", beforeInvocation = true)
    public void deleteBeforeExecution(Long userId) {
        // 先清除缓存，再执行方法
        userMapper.deleteById(userId);
    }
}
```

---

#### 5️⃣ **组合注解（@Cacheable + @CachePut）**

```java
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Caching;

@Service
public class ProductService {
    
    /**
     * 复杂的缓存操作组合
     */
    @Caching(
        put = {
            @CachePut(value = "products", key = "#product.id"),
            @CachePut(value = "products", key = "#product.code")
        },
        evict = {
            @CacheEvict(value = "productList", allEntries = true)
        }
    )
    public ProductDO saveProduct(ProductDO product) {
        // 保存产品
        // 同时按 id 和 code 缓存
        // 清除产品列表缓存
        return product;
    }
    
    /**
     * 多缓存区查询
     */
    @Cacheable(value = {"products", "productDetails"}, key = "#id")
    public ProductDO getProduct(Long id) {
        return productMapper.selectById(id);
    }
}
```

---

### 五、实际业务场景示例

#### 📌 **场景 1：缓存热点数据**

```java
@Service
@Slf4j
public class HotDataService {
    
    @Autowired
    private DataMapper dataMapper;
    
    // 热点数据缓存：最多 500 条，5 分钟过期
    private final LoadingCache<Long, DataDO> hotDataCache = Caffeine.newBuilder()
            .maximumSize(500)
            .expireAfterWrite(5, TimeUnit.MINUTES)
            .recordStats()
            .removalListener((key, value, cause) -> 
                log.info("缓存移除：key={}, value={}, cause={}", key, value, cause)
            )
            .build(key -> {
                log.info("从数据库加载热点数据：{}", key);
                return dataMapper.selectHotDataById(key);
            });
    
    public DataDO getHotData(Long id) {
        return hotDataCache.get(id);
    }
    
    // 监控缓存状态
    @Scheduled(fixedRate = 60000)  // 每分钟打印一次
    public void printStats() {
        CacheStats stats = hotDataCache.stats();
        log.info("=== 热点数据缓存统计 ===");
        log.info("命中率：{:.2%}", stats.hitRate());
        log.info("命中数：{}", stats.hitCount());
        log.info("未命中数：{}", stats.missCount());
        log.info("总请求数：{}", stats.requestCount());
        log.info("平均加载时间：{}ms", stats.averageLoadPenalty() / 1_000_000);
    }
}
```

---

#### 📌 **场景 2：多级缓存**

```java
@Service
public class MultiLevelCacheService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    // L1：Caffeine 本地缓存
    private final Cache<String, Object> l1Cache = Caffeine.newBuilder()
            .maximumSize(100)
            .expireAfterWrite(1, TimeUnit.MINUTES)
            .build();
    
    // L2：Redis 分布式缓存
    
    public Object get(String key) {
        // 1. 查 L1
        Object value = l1Cache.getIfPresent(key);
        if (value != null) {
            return value;
        }
        
        // 2. 查 L2 (Redis)
        value = redisTemplate.opsForValue().get(key);
        if (value != null) {
            // 回写到 L1
            l1Cache.put(key, value);
            return value;
        }
        
        // 3. 查数据库
        value = loadFromDatabase(key);
        if (value != null) {
            // 写入 L2 和 L1
            redisTemplate.opsForValue().set(key, value, 10, TimeUnit.MINUTES);
            l1Cache.put(key, value);
        }
        
        return value;
    }
    
    private Object loadFromDatabase(String key) {
        // 从数据库加载
        return "DB Data: " + key;
    }
}
```

---

#### 📌 **场景 3：防止缓存击穿（互斥锁）**

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.ReentrantLock;

@Service
public class CacheWithLockService {
    
    private final Cache<String, Object> cache = Caffeine.newBuilder()
            .maximumSize(1000)
            .expireAfterWrite(10, TimeUnit.MINUTES)
            .build();
    
    // 互斥锁 Map
    private final ConcurrentHashMap<String, ReentrantLock> lockMap = new ConcurrentHashMap<>();
    
    public Object getWithLock(String key) {
        // 先查缓存
        Object value = cache.getIfPresent(key);
        if (value != null) {
            return value;
        }
        
        // 缓存未命中，加锁
        ReentrantLock lock = lockMap.computeIfAbsent(key, k -> new ReentrantLock());
        lock.lock();
        
        try {
            // 双重检查
            value = cache.getIfPresent(key);
            if (value != null) {
                return value;
            }
            
            // 从数据库加载
            value = loadFromDatabase(key);
            cache.put(key, value);
            
            return value;
        } finally {
            lock.unlock();
            // 清理锁（避免内存泄漏）
            lockMap.remove(key);
        }
    }
    
    private Object loadFromDatabase(String key) {
        return "DB Data: " + key;
    }
}
```

---

### 六、性能优化建议

#### ✅ **最佳实践**

```java
@Configuration
public class OptimalCacheConfig {
    
    @Bean
    public CacheManager optimalCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        
        // 针对不同业务设置不同的缓存策略
        cacheManager.registerCustomCache("hotData", Caffeine.newBuilder()
                .maximumSize(1000)           // 热点数据：容量大
                .expireAfterAccess(5, TimeUnit.MINUTES)  // 访问后过期
                .recordStats()               // 开启统计
                .build());
        
        cacheManager.registerCustomCache("config", Caffeine.newBuilder()
                .maximumSize(100)            // 配置数据：容量小
                .expireAfterWrite(30, TimeUnit.MINUTES)  // 写入后过期
                .build());
        
        cacheManager.registerCustomCache("session", Caffeine.newBuilder()
                .maximumSize(10000)          // 会话数据：容量大
                .expireAfterAccess(30, TimeUnit.MINUTES) // 访问后过期
                .softValues()                // 软引用，内存不足时回收
                .build());
        
        return cacheManager;
    }
}
```

---

### 七、Guava vs Caffeine 对比

| 特性 | Guava Cache | Caffeine |
|------|-------------|----------|
| **命中率算法** | LRU | W-TinyLFU（更优） |
| **吞吐量** | 基准 | **3-5 倍提升** |
| **并发性能** | 分段锁 | 优化锁竞争 |
| **过期策略** | 基础 | 更灵活（Expiry） |
| **异步支持** | 有限 | 原生异步 |
| **维护状态** | ❌ 不再活跃 | ✅ 持续更新 |
| **Spring Boot** | 需手动集成 | **默认集成** |

---

### 八、注意事项 ⚠️

#### 1️⃣ **内存管理**

```java
// ❌ 错误：不设置最大容量
Cache<String, String> cache = Caffeine.newBuilder()
        .build();  // 可能导致 OOM！

// ✅ 正确：必须设置容量限制
Cache<String, String> cache = Caffeine.newBuilder()
        .maximumSize(10000)
        .build();
```

#### 2️⃣ **空值处理**

```java
// ❌ Caffeine 不允许存储 null 值
cache.put("key", null);  // 抛出 NullPointerException

// ✅ 使用 Optional 包装
Cache<String, Optional<Object>> cache = Caffeine.newBuilder()
        .build();
cache.put("key", Optional.empty());  // 可以

// 或使用 get 方法的默认值
Object value = cache.get("key", k -> Optional.empty());
```

#### 3️⃣ **异步缓存异常处理**

```java
AsyncLoadingCache<String, String> cache = Caffeine.newBuilder()
        .buildAsync(key -> {
            if ("error".equals(key)) {
                throw new RuntimeException("加载失败");
            }
            return "Data: " + key;
        });

// 捕获异常
try {
    String value = cache.get("error").join();
} catch (CompletionException e) {
    Throwable cause = e.getCause();  // 获取原始异常
    log.error("缓存加载失败", cause);
}
```

---

### 九、总结

**核心 API 速查表：**

| 功能 | API | 说明 |
|------|-----|------|
| 创建缓存 | `Caffeine.newBuilder()` | 构建器模式 |
| 最大容量 | `.maximumSize(n)` | 限制条目数 |
| 过期时间 | `.expireAfterWrite/Access()` | 自动过期 |
| 自动加载 | `.buildAsync/builder()` | 加载函数 |
| 刷新策略 | `.refreshAfterWrite()` | 定期刷新 |
| 统计监控 | `.recordStats()` | 性能统计 |
| 删除监听 | `.removalListener()` | 删除回调 |
| 权重淘汰 | `.maximumWeight()` + `.weigher()` | 按权重淘汰 |

**推荐使用场景：**

1. ✅ 热点数据缓存（替代 Redis）
2. ✅ 计算结果缓存（避免重复计算）
3. ✅ 本地一级缓存（配合 Redis 二级缓存）
4. ✅ 配置信息缓存
5. ✅ 防抖限流场景

**性能优势：**

- 🚀 接近 HashMap 的读写性能
- 🎯 更高的缓存命中率
- 💾 更低的内存占用
- 🔧 更灵活的淘汰策


