# Perf Baseline Result

- durationSeconds: `10`
- taskMode: `all`

| Scenario | Total | OK | OK Rate | P50(ms) | P95(ms) | P99(ms) | Codes |
|---|---:|---:|---:|---:|---:|---:|---|
| wechatLogin | 100 | 100 | 1.000 | 15.9 | 26.5 | 29.5 | `{"0": 100}` |
| createTask[normal] | 100 | 6 | 0.060 | 10.8 | 23.0 | 24.9 | `{"0": 6, "40015": 94}` |
| createTask[idempotent] | 100 | 0 | 0.000 | 11.1 | 21.7 | 23.6 | `{"40015": 100}` |
| createTask[non_conflict] | 100 | 0 | 0.000 | 10.0 | 20.3 | 21.7 | `{"40015": 52, "40018": 48}` |
| createAdoptionCode | 60 | 0 | 0.000 | 4.8 | 15.5 | 16.6 | `{"40018": 60}` |

- Metric hint: `/actuator/prometheus` -> `longarch_rate_limit_hits_total`