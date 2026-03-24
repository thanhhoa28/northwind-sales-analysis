# Cài đặt thư viện cần thiết
install.packages("readxl")
install.packages("dplyr")
install.packages("lubridate")
install.packages("factoextra")

# Nạp thư viện
library(readxl)
library(xlsx)
library(dplyr)
library(lubridate)
library(factoextra)
#BƯỚC 1
# Đường dẫn tới file Excel
file_path <- "/Users/crystal/Desktop/Northwind Database.xlsx"

# Đọc toàn bộ file Excel (xem qua dữ liệu của sheet đầu tiên)
data <- read_excel(file_path)
print("Xem dữ liệu từ sheet đầu tiên:")
head(data, 5)

# Đọc các sheet cụ thể (ví dụ: Orders và OrderDetails)
orders <- read_excel(file_path, sheet = "orders")  # Đọc sheet Orders
orders_details <- read_excel(file_path, sheet = "orders_details")  # Đọc sheet OrderDetails

# Xem trước dữ liệu
print("Xem trước dữ liệu Orders:")
head(orders, 5)

print("Xem trước dữ liệu OrderDetails:")
head(orders_details, 5)

#BƯỚC 2
# Kiểm tra kiểu dữ liệu của OrderDate và chuyển về kiểu Date
orders$orderdate <- as.Date(orders$orderdate, format = "%Y-%m-%d")

# Tính giá trị tiền của từng đơn hàng
orders_details <- orders_details %>%
  mutate(TotalRevenue = unitprice * quantity)

#BƯỚC 3
# Kết hợp bảng Orders và OrderDetails
rfm_data <- orders %>%
  inner_join(orders_details, by = "orderid") %>%
  group_by(customerid) %>%
  summarise(
    Recency = as.numeric(as.Date("2018-05-31") - max(orderdate)),  # Khoảng cách đến lần mua gần nhất tính từ 31/05/2018
    Frequency = n_distinct(orderid),                                 # Số lần mua hàng
    Monetary = sum(TotalRevenue, na.rm = TRUE)                        # Tổng tiền chi tiêu
  )

# Xem kết quả
print(rfm_data)


#BƯỚC 4
write.csv(rfm_data, "RFM data.csv")

# Chuẩn hóa dữ liệu
rfm_scaled <- rfm_data %>%
  select(Recency, Frequency, Monetary) %>%
  scale()

# Tìm số cụm tối ưu bằng phương pháp Elbow
fviz_nbclust(rfm_scaled, kmeans, method = "wss") +
  labs(title = "Elbow Method for Optimal Clusters")

# Thực hiện K-means
set.seed(123)
k <- 4  # Chọn số cụm (dựa vào kết quả Elbow Method)
kmeans_result <- kmeans(rfm_scaled, centers = k, nstart = 25)

# Gắn nhãn cụm vào dữ liệu RFM
rfm_data$Cluster <- as.factor(kmeans_result$cluster)

# Tạo tóm tắt dữ liệu theo từng cụm
rfm_summary <- rfm_data %>%
  group_by(Cluster) %>%
  summarise(
    Avg_Recency = mean(Recency, na.rm = TRUE),
    Avg_Frequency = mean(Frequency, na.rm = TRUE),
    Avg_Monetary = mean(Monetary, na.rm = TRUE)
  )


print(rfm_summary)

library(plotly)

# Tạo biểu đồ 3D với R, F, M
plot_ly(rfm_data, x = ~Recency, y = ~Frequency, z = ~Monetary, 
        color = ~Cluster, type = 'scatter3d', mode = 'markers') %>%
  layout(title = "3D Customer Segments",
         scene = list(
           xaxis = list(title = "Recency (R)"),
           yaxis = list(title = "Frequency (F)"),
           zaxis = list(title = "Monetary (M)")
         ))

#ĐÁNH GIÁ KẾT QUẢ PHÂN CỤM DỰA TRÊN CÁC ĐIỂM R, F, M
# Bảng quy định cho Recency, Frequency, và Monetary
recency_score <- function(recency) {
  if (recency <= 30) {
    return(5)
  } else if (recency <= 60) {
    return(4)
  } else if (recency <= 120) {
    return(3)
  } else if (recency <= 180) {
    return(2)
  } else {
    return(1)
  }
}

frequency_score <- function(frequency) {
  if (frequency == 1) {
    return(1)
  } else if (frequency <= 5) {
    return(2)
  } else if (frequency <= 10) {
    return(3)
  } else if (frequency <= 15) {
    return(4)
  } else {
    return(5)
  }
}

monetary_score <- function(monetary) {
  if (monetary < 1000) {
    return(1)
  } else if (monetary < 5000) {
    return(2)
  } else if (monetary < 10000) {
    return(3)
  } else if (monetary < 20000) {
    return(4)
  } else {
    return(5)
  }
}

# Áp dụng các bảng quy định vào tóm tắt dữ liệu
rfm_summary <- rfm_summary %>%
  mutate(
    Recency_Score = sapply(Avg_Recency, recency_score),
    Frequency_Score = sapply(Avg_Frequency, frequency_score),
    Monetary_Score = sapply(Avg_Monetary, monetary_score),
    Total_Score = Recency_Score + Frequency_Score + Monetary_Score
  )

# In ra bảng kết quả với các điểm đánh giá
print(rfm_summary)
