Guava Cache 的使用教程。Guava Cache 是一个高性能的本地缓存实现。

## 📚 Guava Cache 使用教程

### 一、Maven 依赖

首先确认项目中已引入 Guava（ruoyi-vue-pro 项目通常已包含）：

```xml
<dependency>
    <groupId>com.google.guava</groupId>
    <artifactId>guava</artifactId>
    <version>33.4.8-jre</version>
</dependency>
```

---

### 二、基本使用示例

#### 1️⃣ **最简单的 Cache 创建**

```java
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

public class SimpleCacheExample {
  
    public static void main(String[] args) {
        // 创建缓存
        Cache<String, Object> cache = CacheBuilder.newBuilder()
                .maximumSize(1000)  // 最大容量
                .build();
      
        // 存入数据
        cache.put("key1", "value1");
        cache.put("key2", "value2");
      
        // 获取数据
        Object value = cache.getIfPresent("key1");
        System.out.println(value);  // value1
      
        // 删除数据
        cache.invalidate("key1");
      
        // 获取不存在的 key，返回 null
        Object notExist = cache.getIfPresent("key3");
        System.out.println(notExist);  // null
    }
}
```

---

#### 2️⃣ **带过期时间的 Cache**

```java
import java.util.concurrent.TimeUnit;

public class ExpiringCacheExample {
  
    public static void main(String[] args) throws InterruptedException {
        Cache<String, String> cache = CacheBuilder.newBuilder()
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

**过期策略对比：**

| 策略                | 说明                       | 适用场景           |
| ------------------- | -------------------------- | ------------------ |
| `expireAfterWrite`  | 写入后固定时间过期         | 配置信息、元数据   |
| `expireAfterAccess` | 最后一次访问后固定时间过期 | 用户会话、热点数据 |
| `refreshAfterWrite` | 写入后固定时间刷新         | 需要定期更新的数据 |

---

#### 3️⃣ **自动加载数据的 Cache（CacheLoader）**

```java
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;

public class LoadingCacheExample {
  
    public static void main(String[] args) throws Exception {
        // 创建带自动加载功能的缓存
        LoadingCache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(1000)
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .build(new CacheLoader<String, String>() {
                    @Override
                    public String load(String key) throws Exception {
                        // 缓存未命中时，自动调用此方法加载数据
                        System.out.println("从数据库加载：" + key);
                        return loadDataFromDatabase(key);
                    }
                });
      
        // 第一次获取，缓存没有，会调用 load 方法
        String user1 = cache.get("user:1");
        System.out.println(user1);
      
        // 第二次获取，直接从缓存返回，不会调用 load 方法
        String user1Again = cache.get("user:1");
        System.out.println(user1Again);
      
    }
  
    private static String loadDataFromDatabase(String key) {
        // 模拟从数据库加载
        return "Data for " + key;
    }
}
```

**Lambda 简化写法：**

```java
LoadingCache<String, String> cache = CacheBuilder.newBuilder()
        .maximumSize(1000)
        .build(key -> loadDataFromDatabase(key));
```

---

#### 4️⃣ **带刷新功能的 Cache**

```java
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import java.util.concurrent.TimeUnit;

public class RefreshCacheExample {
  
    public static void main(String[] args) throws Exception {
        LoadingCache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(1000)
                // 写入后 10 分钟过期
                .expireAfterWrite(10, TimeUnit.MINUTES)
                // 写入后 5 分钟自动刷新（异步）
                .refreshAfterWrite(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, String>() {
                    @Override
                    public String load(String key) {
                        System.out.println("【load】加载数据：" + key);
                        return loadData(key);
                    }
                  
                    @Override
                    public ListenableFuture<String> reload(String key, String oldValue) {
                        // 异步刷新时的回调
                        System.out.println("【reload】刷新数据：" + key);
                        ListenableFutureTask<String> future = ListenableFutureTask.create(() -> loadData(key));
                        future.run();  // 实际应该提交到线程池
                        return future;
                    }
                });
      
        // 首次访问
        cache.get("config:1");
      
        // 5 分钟后再次访问，会触发异步刷新
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
import com.google.common.cache.CacheStats;

public class StatsCacheExample {
  
    public static void main(String[] args) throws InterruptedException {
        LoadingCache<String, String> cache = CacheBuilder.newBuilder()
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
      
        // 打印所有统计
        System.out.println(stats.toString());
    }
  
    private static String loadData(String key) {
        return "Value for " + key;
    }
}
```

---

#### 6️⃣ **删除策略**

```java
public class RemovalCacheExample {
  
    public static void main(String[] args) {
        Cache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(100)
                // 监听删除事件
                .removalListener(notification -> {
                    System.out.println("删除原因：" + notification.getCause());
                    System.out.println("Key: " + notification.getKey());
                    System.out.println("Value: " + notification.getValue());
                })
                .build();
      
        cache.put("key1", "value1");
      
        // 手动删除
        cache.invalidate("key1");
      
        // 批量删除
        cache.put("key2", "value2");
        cache.put("key3", "value3");
        cache.invalidateAll(List.of("key2", "key3"));
      
        // 清空所有
        cache.invalidateAll();
    }
}
```

**删除原因枚举（RemovalCause）：**

- `EXPLICIT`：手动删除
- `REPLACED`：被新值替换
- `COLLECTED`：被 GC 回收（使用 weakKeys/weakValues 时）
- `EXPIRED`：过期
- `SIZE`：超过容量限制

---

### 三、高级特性

#### 1️⃣ **弱引用和软引用**

```java
Cache<String, String> cache = CacheBuilder.newBuilder()
        // 键使用弱引用（GC 可回收）
        .weakKeys()
        // 值使用弱引用
        .weakValues()
        // 值使用软引用（内存不足时才回收）
        .softValues()
        .maximumSize(1000)
        .build();
```

**引用类型对比：**

| 引用类型       | GC 时机    | 适用场景   |
| -------------- | ---------- | ---------- |
| 强引用（默认） | 不回收     | 普通缓存   |
| 弱引用（Weak） | 下次 GC    | 临时缓存   |
| 软引用（Soft） | 内存不足时 | 大对象缓存 |

---

#### 2️⃣ **并发和高性能场景**

```java
import com.google.common.cache.CacheBuilder;
import java.util.concurrent.ConcurrentMap;

public class ConcurrentCacheExample {
  
    public static void main(String[] args) {
        LoadingCache<String, String> cache = CacheBuilder.newBuilder()
                .maximumSize(10000)
                .concurrencyLevel(16)  // 并发级别（分段锁数量）
                .expireAfterWrite(10, TimeUnit.MINUTES)
                .build(key -> {
                    // 模拟耗时操作
                    Thread.sleep(100);
                    return "Data: " + key;
                });
      
        // 高并发访问
        IntStream.range(0, 100).parallel().forEach(i -> {
            try {
                String value = cache.get("key:" + i);
                System.out.println(value);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
      
        // 获取底层并发 Map（可用于自定义操作）
        ConcurrentMap<String, String> map = cache.asMap();
    }
}
```

---

### 四、实际业务场景示例

#### 📌 **场景 1：缓存用户信息**

```java
@Service
public class UserService {
  
    @Autowired
    private UserMapper userMapper;
  
    // 用户缓存：最多 1000 个，10 分钟过期
    private final LoadingCache<Long, UserDO> userCache = CacheBuilder.newBuilder()
            .maximumSize(1000)
            .expireAfterWrite(10, TimeUnit.MINUTES)
            .recordStats()
            .build(new CacheLoader<Long, UserDO>() {
                @Override
                public UserDO load(Long userId) {
                    log.info("从数据库加载用户：{}", userId);
                    return userMapper.selectById(userId);
                }
            });
  
    public UserDO getUser(Long userId) {
        try {
            return userCache.get(userId);
        } catch (Exception e) {
            log.error("获取用户失败", e);
            return null;
        }
    }
  
    // 更新用户时，使缓存失效
    public void updateUser(UserDO user) {
        userMapper.updateById(user);
        userCache.invalidate(user.getId());  // 清除缓存
    }
  
    // 查看缓存统计
    public void printStats() {
        CacheStats stats = userCache.stats();
        log.info("缓存命中率：{}", stats.hitRate());
        log.info("缓存命中数：{}", stats.hitCount());
        log.info("缓存未命中数：{}", stats.missCount());
    }
}
```

---

#### 📌 **场景 2：防止缓存穿透**

```java
@Service
public class ProductService {
  
    @Autowired
    private ProductMapper productMapper;
  
    // 缓存空对象，防止缓存穿透
    private final LoadingCache<Long, Optional<ProductDO>> productCache = CacheBuilder.newBuilder()
            .maximumSize(1000)
            .expireAfterWrite(5, TimeUnit.MINUTES)
            .build(productId -> {
                ProductDO product = productMapper.selectById(productId);
                // 即使为 null 也包装成 Optional，避免缓存 null
                return Optional.ofNullable(product);
            });
  
    public ProductDO getProduct(Long productId) {
        try {
            return productCache.get(productId).orElse(null);
        } catch (Exception e) {
            throw new RuntimeException("查询商品失败", e);
        }
    }
}
```

---

#### 📌 **场景 3：多级缓存**

```java
@Service
public class MultiLevelCacheService {
  
    // 一级缓存：本地 Guava Cache，容量小，过期快
    private final Cache<String, Object> l1Cache = CacheBuilder.newBuilder()
            .maximumSize(100)
            .expireAfterWrite(1, TimeUnit.MINUTES)
            .build();
  
    // 二级缓存：本地 Guava Cache，容量大，过期慢
    private final LoadingCache<String, Object> l2Cache = CacheBuilder.newBuilder()
            .maximumSize(1000)
            .expireAfterWrite(10, TimeUnit.MINUTES)
            .build(key -> loadFromDatabase(key));
  
    public Object get(String key) {
        // 先查 L1
        Object value = l1Cache.getIfPresent(key);
        if (value != null) {
            return value;
        }
      
        // 再查 L2
        try {
            value = l2Cache.get(key);
            // 回写到 L1
            l1Cache.put(key, value);
            return value;
        } catch (Exception e) {
            throw new RuntimeException("查询失败", e);
        }
    }
  
    private Object loadFromDatabase(String key) {
        // 从数据库或 Redis 加载
        return "Data from DB: " + key;
    }
}
```

---

### 五、注意事项 ⚠️

#### 1️⃣ **不适合分布式场景**

```java
// ❌ Guava Cache 是本地缓存，多实例间不共享
// ✅ 分布式场景使用 Redis
@Autowired
private RedisTemplate<String, Object> redisTemplate;
```

#### 2️⃣ **内存泄漏风险**

```java
// ❌ 不设置最大容量，可能导致 OOM
Cache<String, String> cache = CacheBuilder.newBuilder()
        .build();  // 危险！

// ✅ 必须设置容量限制
Cache<String, String> cache = CacheBuilder.newBuilder()
        .maximumSize(10000)
        .build();
```

#### 3️⃣ **刷新操作的线程安全**

```java
// ✅ refreshAfterWrite 是异步的，不会阻塞主线程
.refreshAfterWrite(5, TimeUnit.MINUTES)

// ⚠️ 需要在 reload 中处理异常
@Override
public ListenableFuture<String> reload(String key, String oldValue) {
    return Futures.immediateFuture(loadData(key));  // 同步
    // 或使用线程池异步
    // return executor.submit(() -> loadData(key));
}
```

---

### 六、Guava Cache vs Caffeine

**Caffeine** 是 Guava Cache 的升级版，性能更好：

```xml
<!-- 推荐使用 Caffeine -->
<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
    <version>3.1.8</version>
</dependency>
```

```java
import com.github.benames.caffeine.cache.Cache;
import com.github.benames.caffeine.cache.Caffeine;

Cache<String, String> cache = Caffeine.newBuilder()
        .maximumSize(1000)
        .expireAfterWrite(10, TimeUnit.MINUTES)
        .recordStats()
        .build();
```

**性能对比：**

- Caffeine 命中率更高（W-TinyLFU 算法）
- Caffeine 吞吐量是 Guava 的 3-5 倍
- Spring Boot 默认使用 Caffeine

---

### 七、总结

| 功能     | API                       | 说明             |
| -------- | ------------------------- | ---------------- |
| 基本缓存 | `CacheBuilder`            | 创建缓存         |
| 过期策略 | `expireAfterWrite/Access` | 自动过期         |
| 自动加载 | `CacheLoader`             | 缓存未命中时加载 |
| 异步刷新 | `refreshAfterWrite`       | 定期刷新         |
| 统计监控 | `recordStats()`           | 命中率统计       |
| 删除监听 | `removalListener`         | 删除事件回调     |
| 并发控制 | `concurrencyLevel`        | 并发级别         |

**最佳实践：**

1. ✅ 始终设置 `maximumSize`
2. ✅ 设置合理的过期时间
3. ✅ 使用 `LoadingCache` 简化代码
4. ✅ 监控缓存命中率
5. ✅ 分布式场景用 Redis + 本地 Guava/Caffeine 多级缓存

