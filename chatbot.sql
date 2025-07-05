-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: chatbot_vle
-- ------------------------------------------------------
-- Server version	8.0.42-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `chat_history`
--

DROP TABLE IF EXISTS `chat_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(64) DEFAULT NULL,
  `role` enum('user','assistant') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `danhmuc` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_history`
--

LOCK TABLES `chat_history` WRITE;
/*!40000 ALTER TABLE `chat_history` DISABLE KEYS */;
INSERT INTO `chat_history` VALUES (63,'utjb9vxr2fmcczvemb','user','Dạ em chào thầy cô ạ','2025-06-26 06:20:50',8),(64,'utjb9vxr2fmcczvemb','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-06-26 06:20:50',8),(65,'utjb9vxr2fmcczvemb','user','dạ em chào thầy cô ạ','2025-06-26 06:51:23',8),(66,'utjb9vxr2fmcczvemb','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-06-26 06:51:23',8),(67,'utjb9vxr2fmcczvemb','user','Thầy có email của cô My dạy môn tâm lý học không ạ','2025-06-26 06:53:03',0),(69,'utjb9vxr2fmcczvemb','user','Em muốn xin email của giảng viên môn Tâm lý học đại cương ạ','2025-06-26 07:54:03',0),(71,'utjb9vxr2fmcczvemb','user','Em muốn xin email giảng viên ạ','2025-06-26 09:12:37',9),(72,'utjb9vxr2fmcczvemb','assistant','Nếu giảng viên có thực hiện hướng dẫn trên các khóa học trên VLE thì thông tin email sẽ hiện ở gốc dưới bên phải giao diện khóa học em nhé!','2025-06-26 09:12:37',9),(73,'b704v4ap0dpmce6q57b','user','hệ thống có lịch bảo trì định kì không','2025-06-27 02:23:56',3),(74,'b704v4ap0dpmce6q57b','assistant','Chào em, hệ thống chỉ bảo trì mặc định trong khoảng thời gian 00h đến 06h sáng hằng ngày, còn các thời gian khác có thể hệ thống chỉ bảo trì từ 1 đến 2 phút nên em có thể vào lại ngay nếu truy cập ngoài thời gian bảo trì mặc định.','2025-06-27 02:23:56',3),(77,'8u5ow0gffihmbt386la','user','Chào buổi sáng','2025-06-28 05:34:15',8),(78,'8u5ow0gffihmbt386la','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-06-28 05:34:15',8),(79,'import20250629_01','user','Tôi bị quên mật khẩu, làm sao để khôi phục?','2025-06-29 00:08:10',1),(80,'import20250629_01','assistant','Chào bạn, bạn vui lòng sử dụng chức năng \"Bạn đã quên mật khẩu\" hoặc \"Forgot password\" tại giao diện đăng nhập của hệ thống. Sau đó điền thông tin tài khoản và email sinh viên (mail outlook) mà trường đã cấp ở đầu năm học, hệ thống sẽ gửi đường link để bạn đặt lại mật khẩu mới. Bạn hãy làm theo hướng dẫn này để tự lấy lại mật khẩu nhé!','2025-06-29 00:08:10',1),(81,'import20250629_01','user','Làm sao để đổi mật khẩu tài khoản học tập?','2025-06-29 00:08:10',1),(82,'import20250629_01','assistant','Chào bạn, bạn vui lòng sử dụng chức năng \"Bạn đã quên mật khẩu\" hoặc \"Forgot password\" tại giao diện đăng nhập của hệ thống. Sau đó điền thông tin tài khoản và email sinh viên (mail outlook) mà trường đã cấp ở đầu năm học, hệ thống sẽ gửi đường link để bạn đặt lại mật khẩu mới. Bạn hãy làm theo hướng dẫn này để tự lấy lại mật khẩu nhé!','2025-06-29 00:08:10',1),(85,'import20250629_01','user','Tại sao tôi không đăng nhập được vào hệ thống?','2025-06-29 00:08:15',1),(86,'import20250629_01','assistant','Hiện app đang trong quá trình nâng cấp, em đăng nhập trên trình duyệt để tham gia học tập nhé','2025-06-29 00:08:15',1),(121,'import20250629_03','user','Tôi bị văng ra giữa lúc đang làm bài thi, có thể thi lại không?','2025-06-29 00:13:34',2),(122,'import20250629_03','assistant','Em gửi email về phongcntt@hcmue.edu.vn trình bày vấn đề gặp phải và có đính kèm ảnh chụp màn hình lỗi càng tốt để thầy/cô phòng CNTT hỗ trợ em','2025-06-29 00:13:34',2),(159,'import20250629_05','user','Lịch học của tôi xem ở đâu?','2025-06-29 00:19:31',5),(160,'import20250629_05','assistant','Sinh viên vui lòng chụp minh chứng vấn đề gặp phải và gửi mail về phongcntt@hcmue.edu.vn để thầy/cô hỗ trợ','2025-06-29 00:19:31',5),(255,'import20250629_09','user','Có thể import học viên từ file Excel không?','2025-06-29 00:35:23',0),(267,'import20250629_10','user','Tôi có thể học bất cứ lúc nào không?','2025-06-29 00:37:19',0),(269,'import20250629_10','user','Khóa học có thời hạn không?','2025-06-29 00:37:19',1),(270,'import20250629_10','assistant','Để gia hạn khóa học, vui lòng liên hệ giảng viên để xin gia hạn.\r\nNếu giảng viên chấp nhận, đề nghị giảng viên gửi email về cho phòng CNTT','2025-06-29 00:37:19',1),(275,'import20250629_10','user','Có thể rút khỏi khóa học giữa chừng không?','2025-06-29 00:38:14',1),(276,'import20250629_10','assistant','Để gia hạn khóa học, vui lòng liên hệ giảng viên để xin gia hạn.\r\nNếu giảng viên chấp nhận, đề nghị giảng viên gửi email về cho phòng CNTT','2025-06-29 00:38:14',1),(277,'import20250629_10','user','Tôi có thể xem lại nội dung sau khi học xong không?','2025-06-29 00:38:15',3),(278,'import20250629_10','assistant','Chào em, hệ thống chỉ bảo trì mặc định trong khoảng thời gian 00h đến 06h sáng hằng ngày, còn các thời gian khác có thể hệ thống chỉ bảo trì từ 1 đến 2 phút nên em có thể vào lại ngay nếu truy cập ngoài thời gian bảo trì mặc định.','2025-06-29 00:38:15',3),(301,'import20250629_12','user','Tôi có thể khóa một khóa học tạm thời không?','2025-06-29 00:41:51',1),(302,'import20250629_12','assistant','Để gia hạn khóa học, vui lòng liên hệ giảng viên để xin gia hạn.\r\nNếu giảng viên chấp nhận, đề nghị giảng viên gửi email về cho phòng CNTT','2025-06-29 00:41:52',1),(333,'import20250629_13','user','Có thể upload bài giảng dạng PowerPoint không?','2025-06-29 00:47:02',0),(337,'import20250629_16','user','App có tính năng tải tài liệu không?','2025-06-29 00:58:59',0),(341,'import20250629_19','user','Tôi muốn biết cách thiết kế khóa học hiệu quả.','2025-06-29 01:11:18',4),(342,'import20250629_19','assistant','Chào em, em vui lòng liên hệ giảng viên phụ trách để thầy/cô giải thích chi tiết cho nhé','2025-06-29 01:11:18',4),(345,'wrfbu9d4akmcik99h0','user','chào','2025-06-30 04:04:34',8),(346,'wrfbu9d4akmcik99h0','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-06-30 04:04:34',8),(347,'wrfbu9d4akmcik99h0','user','Khi nào điểm trên VLE mới nhập lên UIS ạ','2025-06-30 04:58:42',0),(348,'wrfbu9d4akmcik99h0','assistant','Thời điểm điểm số trên VLE (Virtual Learning Environment) được nhập lên UIS (University Information System) thường phụ thuộc vào quy định của từng trường đại học hoặc từng chương trình học cụ thể. Thông thường, sau khi cố vấn hoặc giảng viên hoàn tất việc chấm điểm, điểm sẽ được cập nhật lên UIS trong khoảng thời gian từ vài ngày đến vài tuần. \n\nĐể có thông tin chính xác hơn, bạn nên liên hệ trực tiếp với bộ phận hỗ trợ kỹ thuật của trường hoặc giáo viên phụ trách lớp học của bạn. Họ sẽ cung cấp cho bạn lịch trình cụ thể và quy trình nhập điểm.','2025-06-30 04:58:42',0),(349,'wrfbu9d4akmcik99h0','user','khi nào có điểm giữa học kỳ trên vle ạ','2025-06-30 05:00:32',0),(350,'wrfbu9d4akmcik99h0','assistant','Thời gian có điểm giữa học kỳ trên VLE (Virtual Learning Environment) thường được quy định theo lịch học của từng trường đại học. Thông thường, điểm giữa kỳ sẽ được cập nhật sau khi kết thúc giai đoạn thi giữa kỳ, khoảng từ 1 đến 2 tuần sau đó. \n\nTuy nhiên, thời gian cụ thể có thể khác nhau tùy vào chương trình học, số lượng sinh viên, và quy định của từng khoa. Bạn nên theo dõi thông báo từ giảng viên hoặc trên hệ thống VLE của trường để biết thời gian cụ thể. Nếu có thắc mắc, bạn cũng có thể liên hệ với giáo viên hoặc bộ phận quản lý học vụ để được hướng dẫn chi tiết hơn.','2025-06-30 05:00:32',0),(351,'wrfbu9d4akmcik99h0','user','Dạ khi nào mới có điểm ạ','2025-06-30 05:01:46',5),(352,'wrfbu9d4akmcik99h0','assistant','Trong giao diện My course có hiển thị, em xem trong từng ô hiển thị khóa học tương ứng nhé!','2025-06-30 05:01:46',5),(353,'wrfbu9d4akmcik99h0','user','Dạ khi nào mới có điểm ạ','2025-06-30 05:03:18',5),(354,'wrfbu9d4akmcik99h0','assistant','Trong giao diện My course có hiển thị, em xem trong từng ô hiển thị khóa học tương ứng nhé!','2025-06-30 05:03:18',5),(355,'wrfbu9d4akmcik99h0','user','Dạ khi nào mới có điểm ạ','2025-06-30 05:03:59',10),(356,'wrfbu9d4akmcik99h0','assistant','Nếu em nói về điểm bài kiểm tra thì khi làm xong hệ thống sẽ thông báo điểm ngay. Nhưng nếu bài kiểm tra có phần tự luận hoặc nộp file thì cần giảng viên chấm mới hiển thị điểm nhé!','2025-06-30 05:03:59',10),(357,'rgruipr44wdmcjv0gaa','user','chào thầy','2025-07-01 02:12:04',8),(358,'rgruipr44wdmcjv0gaa','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-07-01 02:12:04',8),(359,'wrfbu9d4akmcik99h0','user','Chào thầy','2025-07-02 02:41:13',8),(360,'wrfbu9d4akmcik99h0','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-07-02 02:41:13',8),(361,'wrfbu9d4akmcik99h0','user','Chào thầy','2025-07-02 02:42:00',8),(362,'wrfbu9d4akmcik99h0','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-07-02 02:42:00',8),(363,'wrfbu9d4akmcik99h0','user','bạn biết tôi là ai không','2025-07-02 02:42:41',0),(364,'wrfbu9d4akmcik99h0','assistant','Tôi không biết bạn là ai, vì tôi không có khả năng nhận diện hoặc lưu trữ thông tin cá nhân. Nhưng tôi rất vui được trò chuyện với bạn! Bạn có thể cho tôi biết bạn cần gì không?','2025-07-02 02:42:41',0),(365,'8r10pertbb5mcjx44r3','user','Em có đăng ký học cải thiện môn Tâm lý học đại cương ở học kỳ hè này, sao bây giờ em vẫn chưa thấy hiện khoá học vậy ạ','2025-07-02 10:03:41',0),(366,'8r10pertbb5mcjx44r3','assistant','Chào bạn! Có thể có một số lý do khiến khoá học Tâm lý học đại cương chưa hiện lên trong danh sách môn học của bạn. Bạn có thể thử những bước sau:\n\n1. **Kiểm tra lại thông tin đăng ký**: Đảm bảo rằng bạn đã hoàn tất đăng ký và không gặp vấn đề gì trong quá trình.\n\n2. **Liên hệ với văn phòng đào tạo**: Họ có thể cung cấp thông tin cụ thể về tình hình của khoá học và lý do tại sao nó không hiển thị.\n\n3. **Kiểm tra website của trường**: Đôi khi thông tin về khoá học và lịch trình có thể được cập nhật trên trang web chính thức của trường.\n\nNếu bạn cần thêm thông tin hay sự hỗ trợ khác, cứ cho tôi biết nhé!','2025-07-02 10:03:41',0),(367,'cos4uo46e8rmcmvzwkh','user','Chaof thaayf','2025-07-03 04:30:05',0),(368,'cos4uo46e8rmcmvzwkh','assistant','Chào bạn! Bạn cần giúp gì hôm nay?','2025-07-03 04:30:05',0),(369,'jmjii8jusfdmciufp5w','user','Chào thầy','2025-07-03 09:04:30',8),(370,'jmjii8jusfdmciufp5w','assistant','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE','2025-07-03 09:04:30',8),(371,'wrfbu9d4akmcik99h0','user','điểm trên hệ thống vle được tính như thế nào ạ','2025-07-04 08:17:22',0),(372,'wrfbu9d4akmcik99h0','assistant','Hệ thống VLE (Virtual Learning Environment) thường được sử dụng trong các cơ sở giáo dục để theo dõi tiến trình học tập của học sinh. Điểm số trong hệ thống này có thể được tính theo nhiều cách khác nhau, tùy thuộc vào quy định của từng trường hoặc từng khóa học. Dưới đây là một số phương pháp tính điểm phổ biến:\n\n1. **Chấm điểm từng hoạt động**: Mỗi bài quiz, bài tập, hay bài kiểm tra sẽ có giá trị điểm riêng. Điểm của từng hoạt động sẽ được cộng dồn để tính điểm tổng.\n\n2. **Tỷ lệ phần trăm**: Điểm của các hoạt động sẽ được tính theo tỷ lệ phần trăm. Chẳng hạn, bài kiểm tra giữa kỳ có thể chiếm 30% tổng điểm, bài cuối kỳ 50%, và các bài tập/quiz khác 20%.\n\n3. **Thang điểm**: Một số hệ thống sử dụng thang điểm (ví dụ: từ 0 đến 10 hoặc từ 0 đến 100) để tính điểm cho từng hoạt động và cuối cùng tổng hợp lại để đưa ra điểm tổng.\n\n4. **Điểm trung bình**: Có thể tính điểm trung bình cho các hoạt động học tập trong một khoảng thời gian nhất định.\n\n5. **Hệ số**: Các hoạt động khác nhau có thể có hệ số khác nhau. Ví dụ, một bài kiểm tra có thể có hệ số 2 trong khi một bài tập có hệ số 1.\n\nĐể biết cách tính điểm cụ thể trong hệ thống VLE mà bạn đang sử dụng, tốt nhất là bạn nên tham khảo thông tin từ giáo viên hoặc tài liệu hướng dẫn của trường.','2025-07-04 08:17:22',0),(373,'wrfbu9d4akmcik99h0','user','chào bạn, ngày hôm nay của bạn như thế nào','2025-07-04 08:18:59',0),(374,'wrfbu9d4akmcik99h0','assistant','Chào bạn! Mình không có cảm xúc hay ngày tháng giống như con người, nhưng mình luôn sẵn sàng giúp đỡ bạn. Bạn có câu hỏi hay điều gì muốn thảo luận không?','2025-07-04 08:18:59',0),(375,'wrfbu9d4akmcik99h0','user','Mình có thể xem lại dữ liệu khóa học khi đã hết hạn không','2025-07-04 08:19:54',0),(376,'wrfbu9d4akmcik99h0','assistant','Thông thường, quyền truy cập vào dữ liệu khóa học sau khi đã hết hạn phụ thuộc vào chính sách của nền tảng hoặc tổ chức cung cấp khóa học. Một số nền tảng có thể cho phép bạn xem lại tài liệu hoặc ghi âm bài giảng, trong khi những nơi khác có thể không cho phép.\n\nNếu bạn muốn xem lại dữ liệu khóa học đã hết hạn, hãy thử những bước sau:\n\n1. **Kiểm tra Email:** Một số nền tảng gửi email với liên kết đến tài liệu hay bộ tài liệu đã học.\n   \n2. **Đăng Nhập Tài Khoản:** Nếu bạn vẫn có thể đăng nhập vào tài khoản của mình, kiểm tra xem có phần nào cho phép truy cập vào tài liệu cũ không.\n\n3. **Liên Hệ Hỗ Trợ:** Nếu bạn không thể tìm thấy thông tin, hãy liên hệ với bộ phận hỗ trợ của nền tảng để hỏi về khả năng phục hồi dữ liệu khóa học.\n\n4. **Tìm Kiếm Trên Diễn Đàn Học Tập:** Nếu khóa học thuộc một cộng đồng hoặc diễn đàn, có thể có thông tin từ các học viên khác về cách truy cập vào dữ liệu khóa học cũ.\n\nHy vọng thông tin này hữu ích cho bạn!','2025-07-04 08:19:54',0);
/*!40000 ALTER TABLE `chat_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danhmuc`
--

DROP TABLE IF EXISTS `danhmuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danhmuc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ten` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danhmuc`
--

LOCK TABLES `danhmuc` WRITE;
/*!40000 ALTER TABLE `danhmuc` DISABLE KEYS */;
INSERT INTO `danhmuc` VALUES (1,'Tài khoản'),(2,'Chức năng'),(3,'Chung'),(4,'Kịch bản'),(5,'Khóa học'),(6,'Hệ thống'),(8,'Chào hỏi'),(9,'Thông tin email'),(10,'Điểm');
/*!40000 ALTER TABLE `danhmuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `data`
--

DROP TABLE IF EXISTS `data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `danhmuc` int DEFAULT NULL,
  `cauhoi` varchar(255) DEFAULT NULL,
  `cautraloi` text,
  PRIMARY KEY (`id`),
  KEY `fk_danhmuc` (`danhmuc`),
  CONSTRAINT `fk_danhmuc` FOREIGN KEY (`danhmuc`) REFERENCES `danhmuc` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `data`
--

LOCK TABLES `data` WRITE;
/*!40000 ALTER TABLE `data` DISABLE KEYS */;
INSERT INTO `data` VALUES (6,5,'Không tìm thấy học liệu của khóa học','Sinh viên vui lòng chụp minh chứng vấn đề gặp phải và gửi mail về phongcntt@hcmue.edu.vn để thầy/cô hỗ trợ'),(7,4,'Không thực hiện được bài kiểm tra vì hệ thống báo hết số lần thực hiện','Đây là kịch bản sư phạm mà giảng viên xây dựng khóa đã tạo, bạn vui lòng liên hệ giảng viên phụ trách lớp để được giải đáp chi tiết'),(8,2,'Thầy/Cô cho phép em làm lại bài kiểm tra vì em đang làm thì bị lỗi nên văng ra chưa kịp bấm nộp bài (submit)','Em gửi email về phongcntt@hcmue.edu.vn trình bày vấn đề gặp phải và có đính kèm ảnh chụp màn hình lỗi càng tốt để thầy/cô phòng CNTT hỗ trợ em'),(9,2,'Em bấm nộp nhưng hệ thống vẫn không chấp nhận','Sau khi bấm submit lần 1, hệ thống sẽ hiển thị dòng thông báo yêu cầu người học kiểm tra lại bài làm của mình một lần nữa để chắc chắn trước khi nộp bài, em lưu ý nhé'),(10,3,'Khi nào hệ thống bảo trì xong để em có thể tiếp tục học','Chào em, hệ thống chỉ bảo trì mặc định trong khoảng thời gian 00h đến 06h sáng hằng ngày, còn các thời gian khác có thể hệ thống chỉ bảo trì từ 1 đến 2 phút nên em có thể vào lại ngay nếu truy cập ngoài thời gian bảo trì mặc định.'),(11,2,'Em đã làm các hoạt động bắt buộc nhưng đến hoạt động tiếp theo bị khóa và không thể mở được','Em cần phải làm tuần tự từ trên xuống để các hoạt động bị khóa được mở lần lượt'),(12,2,'Phần nút tam giác bắt đầu bài làm của em đều bị ẩn hết, không thể thao tác được','Em vui lòng xem còn hoạt động nào ở trên chưa làm hay không'),(13,2,'Hôm trước em đang làm bài thì hệ thống tự out ra ngoài và không cho e làm lại do bị giới hạn chỉ 1 lần làm ạ. Nếu không làm được bài quiz thì em sẽ không được nộp các bài ở dưới và đánh giá hoàn thành khóa học ạ.','Em gửi email về phongcntt@hcmue.edu.vn trình bày vấn đề gặp phải và có đính kèm ảnh chụp màn hình lỗi càng tốt để thầy/cô phòng CNTT hỗ trợ em'),(14,4,'Em muốn biết khóa học này tính điểm như thế nào ạ','Chào em, em vui lòng liên hệ giảng viên phụ trách để thầy/cô giải thích chi tiết cho nhé'),(15,1,'Em muốn được cấp tài khoản thì như thế nào ạ','Chào em, hiện tại trường chỉ cấp cho đối tượng là người học của trường, chưa có chính sách cấp tài khoản cho đối tượng khác em nhé!'),(16,6,'Hệ thống load lâu và em bị out ra ngoài không học tiếp được','Chào em, hiện tại đang có quá nhiều người cùng truy cập nên hệ thống sẽ tải chậm, em có thể quay lại sau hoặc học ở khoảng thời gian khác em nhé!'),(17,5,'Em có đăng ký học phần Pháp luật đại cương nhưng chưa thấy trên tài khoản ạ','Chào em, khi có lớp học trên VLE chúng tôi sẽ gửi email thông báo nhé, em kiểm tra email sinh viên (hộp thư đến hoặc spam) đã có nhận thông báo hay chưa, nếu chưa thì khóa học đang trong giai đoạn triển khai chưa gán lớp nên em chờ thông báo nhé.'),(18,5,'Em thấy các bạn cùng lớp đã có lớp rồi ạ','Em gửi email về cho hotrovle@hcmue.edu.vn để bộ phận hỗ trợ xem là vấn đề ở đâu nhé.'),(19,1,'Làm sao lấy lại được mật khẩu','Chào bạn, bạn vui lòng sử dụng chức năng \"Bạn đã quên mật khẩu\" hoặc \"Forgot password\" tại giao diện đăng nhập của hệ thống. Sau đó điền thông tin tài khoản và email sinh viên (mail outlook) mà trường đã cấp ở đầu năm học, hệ thống sẽ gửi đường link để bạn đặt lại mật khẩu mới. Bạn hãy làm theo hướng dẫn này để tự lấy lại mật khẩu nhé!'),(23,8,'Dạ em chào thầy cô ạ','Chào bạn, chúng tôi là đội ngũ hỗ trợ VLE'),(24,5,'Khi nào khóa học của em mới hết hạn ạ','Trong giao diện My course có hiển thị, em xem trong từng ô hiển thị khóa học tương ứng nhé!'),(25,9,'Dạ thầy có email của thầy Huỳnh Văn Sơn dạy môn Nhập môn nghề giáo không ạ','Nếu giảng viên có thực hiện hướng dẫn trên các khóa học trên VLE thì thông tin email sẽ hiện ở gốc dưới bên phải giao diện khóa học em nhé!'),(26,9,'Em muốn xin email của giảng viên ạ','Nếu giảng viên có thực hiện hướng dẫn trên các khóa học trên VLE thì thông tin email sẽ hiện ở gốc dưới bên phải giao diện khóa học em nhé!'),(27,9,'Thầy có email của cô My dạy môn tâm lý học không ạ','Nếu giảng viên có thực hiện hướng dẫn trên các khóa học trên VLE thì thông tin email sẽ hiện ở gốc dưới bên phải giao diện khóa học em nhé!'),(28,6,'Có thể import học viên từ file Excel không?','Chào bạn, nếu bạn là quản trị viên thì bạn có thể hoàn toàn làm được việc này, riêng đối với vai trò là giáo viên hay người tạo khóa thì không thể nhé!'),(29,2,'App có tính năng tải tài liệu không?','Chào bạn, hiện tại App di động đang trong tình trạng bảo trì, bạn truy cập bằng trình duyệt qua link: vle.hcmue.edu.vn nhé!'),(30,10,'Khi nào điểm trên VLE mới nhập lên UIS ạ','Nếu điểm trên VLE lấy để làm điểm quá trình hoặc kết thúc học phần thì thời gian nhập điểm phụ thuộc vào giảng viên em nhé'),(31,10,'khi nào có điểm giữa học kỳ trên vle ạ','Phụ thuộc vào giảng viên em nhé'),(32,10,'Dạ khi nào mới có điểm ạ','Nếu em nói về điểm bài kiểm tra thì khi làm xong hệ thống sẽ thông báo điểm ngay. Nhưng nếu bài kiểm tra có phần tự luận hoặc nộp file thì cần giảng viên chấm mới hiển thị điểm nhé!'),(33,1,'Em có đăng ký học cải thiện môn Tâm lý học đại cương ở học kỳ hè này, sao bây giờ em vẫn chưa thấy hiện khoá học vậy ạ','Chào em, em gửi mail về hỗ trợ vle: hotrovle@hcmue.edu.vn để chúng tôi kiểm tra nhé!'),(34,2,'Mình có thể xem lại dữ liệu khóa học khi đã hết hạn không','Hoàn toàn có thể, tuy nhiên bạn không thể thực hiện các bài kiểm tra nhé!');
/*!40000 ALTER TABLE `data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mapping_data`
--

DROP TABLE IF EXISTS `mapping_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mapping_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `data_id` int NOT NULL,
  `chat_history_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `data_id` (`data_id`),
  KEY `chat_history_id` (`chat_history_id`),
  CONSTRAINT `mapping_data_ibfk_1` FOREIGN KEY (`data_id`) REFERENCES `data` (`id`),
  CONSTRAINT `mapping_data_ibfk_2` FOREIGN KEY (`chat_history_id`) REFERENCES `chat_history` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mapping_data`
--

LOCK TABLES `mapping_data` WRITE;
/*!40000 ALTER TABLE `mapping_data` DISABLE KEYS */;
INSERT INTO `mapping_data` VALUES (1,27,67,'2025-06-26 09:12:05'),(2,27,69,'2025-06-26 09:12:05'),(3,28,255,'2025-06-29 01:21:01'),(4,28,267,'2025-06-29 01:21:01'),(5,28,333,'2025-06-29 01:21:01'),(6,29,337,'2025-06-29 05:25:30'),(7,30,347,'2025-06-30 05:00:06'),(8,31,349,'2025-06-30 05:01:37'),(9,33,365,'2025-07-04 01:52:03'),(10,34,375,'2025-07-04 08:20:41');
/*!40000 ALTER TABLE `mapping_data` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-05 10:33:13
