# 🚀 Free AWS Setup for ecom.com

## 💰 **Total Cost: $12/year** (just the domain!)

### **What's Free:**
- ✅ **AWS Lambda**: 1M requests/month free
- ✅ **DynamoDB**: 25GB storage + 25WCU/25RCU free
- ✅ **S3**: 5GB storage free
- ✅ **CloudFront**: 1TB data transfer free
- ✅ **API Gateway**: 1M requests/month free
- ✅ **Route 53**: $12/year for domain only

---

## 🏗️ **Architecture**

```
ecom.com (Route 53)
    ↓
CloudFront (CDN)
    ↓
├── S3 (Frontend) ← Static files
└── API Gateway ← Backend
    ↓
Lambda (Your Spring Boot app)
    ↓
DynamoDB (Database)
```

---

## 🚀 **Step-by-Step Deployment**

### **Step 1: Prerequisites**
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Configure AWS credentials
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your region (us-east-1)

# Install Serverless Framework
npm install -g serverless
```

### **Step 2: Deploy Backend**
```bash
# Deploy your Spring Boot app to Lambda
./deploy-free-aws.sh
```

### **Step 3: Register Domain**
1. Go to [Route 53 Console](https://console.aws.amazon.com/route53)
2. Click "Register Domain"
3. Search for "ecom.com"
4. Complete registration ($12/year)

### **Step 4: Set Up SSL Certificate**
```bash
# Request SSL certificate
aws acm request-certificate \
  --domain-name ecom.com \
  --subject-alternative-names www.ecom.com \
  --validation-method DNS \
  --region us-east-1
```

### **Step 5: Update CloudFront**
1. Go to CloudFront console
2. Find your distribution
3. Add your domain to "Alternate Domain Names"
4. Select your SSL certificate

### **Step 6: Upload Frontend**
```bash
# Get your S3 bucket name
aws s3 ls | grep ecom-frontend

# Upload your frontend files
aws s3 sync ./frontend/ s3://your-bucket-name/
```

---

## 🔧 **What You Need to Provide**

### **AWS Credentials (Required)**
```bash
# Your AWS Access Key ID
AWS_ACCESS_KEY_ID=AKIA...

# Your AWS Secret Access Key  
AWS_SECRET_ACCESS_KEY=...

# Your AWS Region
AWS_REGION=us-east-1
```

### **Domain Registration (Required)**
- **Domain**: ecom.com ($12/year)
- **SSL Certificate**: Free with AWS Certificate Manager

### **Frontend Files (Required)**
Create a `frontend/` folder with:
- `index.html`
- `styles.css`
- `script.js`
- Any images/assets

---

## 📊 **Free Tier Limits**

| Service | Free Tier | Your Usage |
|---------|-----------|------------|
| **Lambda** | 1M requests/month | ~10K requests/month |
| **DynamoDB** | 25GB + 25WCU/25RCU | ~1GB storage |
| **S3** | 5GB storage | ~100MB |
| **CloudFront** | 1TB transfer | ~10GB |
| **API Gateway** | 1M requests/month | ~10K requests/month |

**You'll likely stay within free tier! 🎉**

---

## 🎯 **Cost Breakdown**

| Item | Cost |
|------|------|
| **Domain (ecom.com)** | $12/year |
| **AWS Services** | $0/month (free tier) |
| **SSL Certificate** | $0 (AWS Certificate Manager) |
| **Total** | **$12/year** |

---

## 🔒 **Security Features**

### **What's Secured**
- ✅ **HTTPS**: Automatic SSL certificates
- ✅ **API Gateway**: Rate limiting and throttling
- ✅ **CloudFront**: DDoS protection
- ✅ **DynamoDB**: Encryption at rest and in transit
- ✅ **Lambda**: Execution in VPC (if needed)

### **What You Should Do**
- 🔒 Use strong passwords for admin accounts
- 🔒 Enable CloudTrail for audit logs
- 🔒 Set up billing alerts
- 🔒 Regularly update dependencies

---

## 📈 **Scaling (When Needed)**

### **Automatic Scaling**
- **Lambda**: Scales automatically based on requests
- **DynamoDB**: Pay-per-request billing
- **CloudFront**: Global CDN with edge locations
- **API Gateway**: Handles traffic spikes

### **Cost When You Scale**
- **Lambda**: $0.20 per 1M requests (after free tier)
- **DynamoDB**: $1.25 per million requests (after free tier)
- **CloudFront**: $0.085 per GB (after free tier)

**Even with 100K requests/month, you'd pay ~$5-10/month!**

---

## 🚀 **Quick Start Commands**

```bash
# 1. Configure AWS
aws configure

# 2. Deploy backend
./deploy-free-aws.sh

# 3. Register domain in Route 53 console

# 4. Upload frontend
aws s3 sync ./frontend/ s3://your-bucket-name/

# 5. Update CloudFront with your domain
```

---

## 🆘 **Troubleshooting**

### **Common Issues**

1. **"Lambda function not found"**
   ```bash
   serverless deploy --stage prod
   ```

2. **"Domain not accessible"**
   - Check Route 53 DNS settings
   - Verify SSL certificate is attached to CloudFront

3. **"S3 bucket not found"**
   ```bash
   aws s3 ls | grep ecom-frontend
   ```

### **Monitoring**
```bash
# Check Lambda logs
aws logs describe-log-groups --log-group-name-prefix /aws/lambda/sb-ecom-serverless

# Check DynamoDB metrics
aws cloudwatch get-metric-statistics --namespace AWS/DynamoDB --metric-name ConsumedReadCapacityUnits
```

---

## 🎉 **Success!**

Once deployed, your eCommerce site will be available at:
```
https://ecom.com
```

**API Endpoints:**
- Health: `GET https://ecom.com/api/actuator/health`
- Products: `GET https://ecom.com/api/products`
- Categories: `GET https://ecom.com/api/categories`

---

## 💡 **Why This is Perfect for Minimal Production**

- ✅ **Free**: Only pay for domain ($12/year)
- ✅ **Scalable**: Auto-scales with traffic
- ✅ **Global**: CloudFront CDN worldwide
- ✅ **Secure**: HTTPS, WAF, DDoS protection
- ✅ **Reliable**: AWS managed services
- ✅ **Fast**: Lambda cold starts < 1 second

**Perfect for a simple eCommerce site with minimal traffic! 🚀** 