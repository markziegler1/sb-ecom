# Enterprise-Grade eCommerce Platform Setup

## 🏗️ Architecture Overview

This setup provides a production-ready, scalable eCommerce platform with:

- **AWS RDS PostgreSQL** - Managed, high-availability database
- **AWS ElastiCache Redis** - High-performance caching layer
- **AWS ECS Fargate** - Serverless container orchestration
- **AWS Application Load Balancer** - SSL termination and health checks
- **AWS CloudWatch** - Comprehensive monitoring and alerting
- **AWS S3 + CloudFront** - Static file hosting and CDN

## 🚀 Quick Start

### 1. Local Development Setup

```bash
# Start local development environment
docker-compose up -d

# Access the application
curl http://localhost:8080/api/actuator/health

# Access H2 console (development only)
open http://localhost:8080/h2-console
```

### 2. Production Deployment

```bash
# Deploy to AWS (requires AWS CLI configured)
./deploy.sh
```

## 📋 Prerequisites

### AWS Setup
1. **AWS Account** with appropriate permissions
2. **AWS CLI** installed and configured
3. **Docker** installed and running
4. **Java 21** and **Maven** for local development

### Required AWS Services
- **RDS PostgreSQL** (Multi-AZ)
- **ElastiCache Redis** (Multi-AZ)
- **ECS Fargate** cluster
- **Application Load Balancer**
- **ECR** repository
- **S3** bucket for file storage
- **CloudWatch** for monitoring

## 🔧 Configuration

### Environment Variables

Create a `.env` file for local development:

```bash
# Database
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/sb_ecom_db
SPRING_DATASOURCE_USERNAME=sb_ecom_user
SPRING_DATASOURCE_PASSWORD=sb_ecom_password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRATION=86400000

# Application
ALLOWED_ORIGINS=http://localhost:3000
LOG_LEVEL=INFO
```

### AWS Parameter Store (Production)

Store sensitive configuration in AWS Systems Manager Parameter Store:

```bash
# Database configuration
aws ssm put-parameter --name "/sb-ecom/prod/database/url" --value "jdbc:postgresql://your-rds-endpoint:5432/sb_ecom_db" --type "SecureString"
aws ssm put-parameter --name "/sb-ecom/prod/database/username" --value "sb_ecom_user" --type "SecureString"
aws ssm put-parameter --name "/sb-ecom/prod/database/password" --value "your-secure-password" --type "SecureString"

# Redis configuration
aws ssm put-parameter --name "/sb-ecom/prod/redis/host" --value "your-elasticache-endpoint" --type "SecureString"
aws ssm put-parameter --name "/sb-ecom/prod/redis/password" --value "your-redis-password" --type "SecureString"

# JWT configuration
aws ssm put-parameter --name "/sb-ecom/prod/jwt/secret" --value "your-super-secret-jwt-key" --type "SecureString"
```

## 🏗️ Infrastructure Setup

### 1. RDS PostgreSQL Setup

```bash
# Create RDS instance (via AWS Console or CLI)
aws rds create-db-instance \
  --db-instance-identifier sb-ecom-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username sb_ecom_user \
  --master-user-password your-secure-password \
  --allocated-storage 20 \
  --storage-type gp2 \
  --multi-az \
  --backup-retention-period 7 \
  --enable-performance-insights
```

### 2. ElastiCache Redis Setup

```bash
# Create Redis cluster
aws elasticache create-replication-group \
  --replication-group-id sb-ecom-redis \
  --replication-group-description "Redis cluster for eCommerce" \
  --node-type cache.t3.micro \
  --num-cache-clusters 2 \
  --automatic-failover-enabled \
  --multi-az-enabled
```

### 3. ECS Cluster Setup

```bash
# Create ECS cluster
aws ecs create-cluster --cluster-name sb-ecom-cluster

# Create task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json

# Create service
aws ecs create-service \
  --cluster sb-ecom-cluster \
  --service-name sb-ecom-service \
  --task-definition sb-ecom-task \
  --desired-count 2 \
  --launch-type FARGATE
```

## 📊 Monitoring & Alerting

### CloudWatch Dashboards

Create custom dashboards for:
- **Application Metrics**: Response time, error rate, throughput
- **Database Metrics**: Connections, CPU, memory, storage
- **Cache Metrics**: Hit rate, memory usage, connections
- **Infrastructure Metrics**: CPU, memory, network

### Alerts

Set up CloudWatch alarms for:
- **High CPU/Memory usage** (>80%)
- **High error rate** (>5%)
- **Slow response time** (>2 seconds)
- **Database connection issues**
- **Cache hit rate** (<80%)

## 🔒 Security

### Network Security
- **VPC** with private subnets for database and cache
- **Security Groups** with minimal required access
- **WAF** for application load balancer
- **SSL/TLS** termination at load balancer

### Data Security
- **Encryption at rest** for all data stores
- **Encryption in transit** for all communications
- **IAM roles** for service-to-service authentication
- **Secrets Manager** for sensitive configuration

## 📈 Scaling Strategy

### Auto Scaling
- **CPU-based scaling**: Scale when CPU > 70%
- **Memory-based scaling**: Scale when memory > 80%
- **Custom metrics**: Scale based on business metrics

### Database Scaling
- **Read replicas** for read-heavy workloads
- **Connection pooling** for efficient resource usage
- **Query optimization** and indexing

### Cache Strategy
- **Product catalog**: 1-hour TTL
- **User sessions**: 15-minute TTL
- **Categories**: 24-hour TTL
- **Search results**: 30-minute TTL

## 🚀 Performance Optimization

### Application Level
- **Caching** with Redis for frequently accessed data
- **Connection pooling** for database connections
- **Async processing** for non-critical operations
- **CDN** for static assets

### Database Level
- **Proper indexing** on frequently queried columns
- **Query optimization** and monitoring
- **Connection pooling** and management
- **Read replicas** for read operations

### Infrastructure Level
- **Load balancing** across multiple instances
- **Auto-scaling** based on demand
- **CDN** for global content delivery
- **Monitoring** and alerting

## 🔧 Troubleshooting

### Common Issues

1. **Database Connection Issues**
   ```bash
   # Check RDS connectivity
   aws rds describe-db-instances --db-instance-identifier sb-ecom-db
   ```

2. **Cache Connection Issues**
   ```bash
   # Check ElastiCache status
   aws elasticache describe-replication-groups --replication-group-id sb-ecom-redis
   ```

3. **Application Health**
   ```bash
   # Check application health
   curl https://your-domain.com/api/actuator/health
   ```

### Logs and Monitoring

- **Application logs**: CloudWatch Logs
- **Database logs**: RDS console
- **Cache logs**: ElastiCache console
- **Load balancer logs**: S3 bucket

## 📚 Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [Spring Boot Production Guide](https://spring.io/guides/gs/spring-boot/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

## 🆘 Support

For issues or questions:
1. Check CloudWatch logs and metrics
2. Review application health endpoints
3. Verify infrastructure status in AWS Console
4. Check security group and network ACL configurations 