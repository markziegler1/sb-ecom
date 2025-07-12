# 🚀 Get Your eCommerce Site Online in 10 Minutes

## 💰 **Cost: $0/month**
## ⏱️ **Time: 10 minutes**

---

## 🎯 **Step 1: Deploy Backend (5 minutes)**

### **Option A: Railway (Recommended)**
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "New Project" → "Deploy from GitHub repo"
4. Select your repository
5. Railway automatically detects it's a Java app and deploys it
6. Copy the URL (e.g., `https://your-app-name.railway.app`)

### **Option B: Render (Alternative)**
1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Click "New" → "Web Service"
4. Connect your GitHub repository
5. Set build command: `./mvnw clean package -DskipTests`
6. Set start command: `java -jar target/*.jar`
7. Deploy

---

## 🎯 **Step 2: Deploy Frontend (5 minutes)**

### **Option A: Netlify (Recommended)**
1. Go to [netlify.com](https://netlify.com)
2. Sign up with GitHub
3. Drag and drop the `index.html` file to deploy
4. Or connect your GitHub repo and it auto-deploys

### **Option B: GitHub Pages (Free)**
1. Push your code to GitHub
2. Go to repository settings
3. Enable GitHub Pages
4. Select source branch

---

## 🔧 **Step 3: Connect Frontend to Backend**

Edit the `index.html` file and change this line:
```javascript
const API_URL = 'https://your-app-name.railway.app/api';
```
Replace `your-app-name` with your actual Railway app name.

---

## 🎉 **That's It!**

Your website is now live at:
- **Netlify**: `https://your-site-name.netlify.app`
- **GitHub Pages**: `https://your-username.github.io/your-repo`

---

## 📊 **What You Get**

| Service | Cost | What it does |
|---------|------|--------------|
| **Railway** | $0-5/month | Runs your Spring Boot backend |
| **Netlify** | $0/month | Hosts your frontend |
| **PostgreSQL** | $0/month | Database (included with Railway) |
| **Custom Domain** | $12/year | Optional: your own domain |

---

## 🔧 **If Something Doesn't Work**

### **Backend Issues:**
1. Check Railway logs in the dashboard
2. Make sure your app starts with: `java -jar target/*.jar`
3. Verify the port is set to `8080`

### **Frontend Issues:**
1. Check browser console for errors
2. Make sure the API_URL is correct
3. Verify CORS is enabled in your backend

### **Database Issues:**
1. Railway automatically creates a PostgreSQL database
2. Your app will auto-connect to it
3. Check Railway dashboard for database URL

---

## 🚀 **Quick Commands**

```bash
# Test your backend locally
./mvnw spring-boot:run

# Build for production
./mvnw clean package -DskipTests

# Your app will be at: http://localhost:8080/api/products
```

---

## 💡 **Pro Tips**

1. **Railway automatically:**
   - Detects your Java app
   - Creates PostgreSQL database
   - Sets environment variables
   - Handles SSL certificates

2. **Netlify automatically:**
   - Provides HTTPS
   - Handles custom domains
   - Auto-deploys on Git push

3. **Your app automatically:**
   - Connects to the database
   - Exposes REST API
   - Handles CORS for frontend

---

## 🎯 **Success Checklist**

- ✅ Backend deployed to Railway
- ✅ Frontend deployed to Netlify
- ✅ API_URL updated in index.html
- ✅ Website loads and shows products
- ✅ Add to cart buttons work

**You now have a working eCommerce site for $0/month! 🎉** 