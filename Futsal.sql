-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2025 at 10:57 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `futsal`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `id_field` int(11) DEFAULT NULL,
  `id_payment` int(11) DEFAULT NULL,
  `admin_name` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `id_field`, `id_payment`, `admin_name`, `password`) VALUES
(1, 1, 1, 'admin_jkt', 'admin123'),
(2, 2, 2, 'admin_bdg', 'bdgsecure'),
(4, 4, 4, 'admin_jogja', 'jogjaadmin'),
(5, 5, 5, 'admin_depok', 'depokpass');

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id_booking` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `id_field` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `finish_time` time DEFAULT NULL,
  `total_cost` decimal(10,2) DEFAULT NULL,
  `status` enum('Pending','Confirmed','Canceled') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id_booking`, `id_user`, `id_field`, `date`, `start_time`, `finish_time`, `total_cost`, `status`) VALUES
(1, 1, 1, '2025-06-05', '10:00:00', '12:00:00', 300000.00, 'Confirmed'),
(2, 2, 2, '2025-06-06', '14:00:00', '16:00:00', 240000.00, 'Confirmed'),
(3, 3, 3, '2025-06-07', '18:00:00', '20:00:00', 260000.00, 'Canceled'),
(4, 4, 4, '2025-06-08', '08:00:00', '10:00:00', 220000.00, 'Confirmed'),
(5, 5, 5, '2025-06-09', '16:00:00', '18:00:00', 250000.00, 'Confirmed');

--
-- Triggers `booking`
--
DELIMITER $$
CREATE TRIGGER `trg_confirm_payment` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
IF NEW.status = 'Confirmed' THEN
UPDATE Payment
SET payment_status = 'Paid Off'
WHERE id_booking = NEW.id_booking;
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `field`
--

CREATE TABLE `field` (
  `id_field` int(11) NOT NULL,
  `location` varchar(20) DEFAULT NULL,
  `hourly_charge` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `field`
--

INSERT INTO `field` (`id_field`, `location`, `hourly_charge`) VALUES
(1, 'Jakarta Selatan', 150000.00),
(2, 'Magelang', 120000.00),
(3, 'Bandung', 130000.00),
(4, 'Yogyakarta', 110000.00),
(5, 'Depok', 125000.00);

-- --------------------------------------------------------

--
-- Stand-in structure for view `paidbookings`
-- (See below for the actual view)
--
CREATE TABLE `paidbookings` (
`id_booking` int(11)
,`username` varchar(50)
,`location` varchar(20)
,`payment_status` enum('Paid Off','Unpaid')
);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `id_payment` int(11) NOT NULL,
  `id_booking` int(11) DEFAULT NULL,
  `metode` enum('Cash','Transfer') DEFAULT NULL,
  `payment_status` enum('Paid Off','Unpaid') DEFAULT NULL,
  `transfer_slip` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`id_payment`, `id_booking`, `metode`, `payment_status`, `transfer_slip`) VALUES
(1, 1, 'Cash', 'Paid Off', 'slip1.jpg'),
(2, 2, 'Transfer', 'Unpaid', 'slip2.jpg'),
(3, 3, 'Cash', 'Unpaid', 'slip3.jpg'),
(4, 4, 'Transfer', 'Paid Off', 'slip4.jpg'),
(5, 5, 'Cash', 'Paid Off', 'slip5.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(15) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `username`, `email`, `contact`, `password`) VALUES
(1, 'Andi', 'Andi12@gmail.com', '081122334543', 'Andi123'),
(2, 'Rexy', 'RexyPratama0@gmail.com', '081872334543', 'Rexyy1'),
(3, 'Vero', 'Bryanvero0@gmail.com', '081872304913', 'Vero99'),
(4, 'Ilham22', 'Ilham@example.com', '084567890123', 'Ilham123'),
(5, 'Dinda76', 'Dinda@example.com', '085678901234', 'dinda321');

-- --------------------------------------------------------

--
-- Structure for view `paidbookings`
--
DROP TABLE IF EXISTS `paidbookings`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `paidbookings`  AS SELECT `b`.`id_booking` AS `id_booking`, `u`.`username` AS `username`, `f`.`location` AS `location`, `p`.`payment_status` AS `payment_status` FROM (((`booking` `b` join `user` `u` on(`b`.`id_user` = `u`.`id_user`)) join `field` `f` on(`b`.`id_field` = `f`.`id_field`)) join `payment` `p` on(`b`.`id_booking` = `p`.`id_booking`)) WHERE `p`.`payment_status` = 'Paid Off' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`),
  ADD KEY `id_field` (`id_field`),
  ADD KEY `id_payment` (`id_payment`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id_booking`),
  ADD KEY `id_user` (`id_user`),
  ADD KEY `id_field` (`id_field`),
  ADD KEY `idx_booking_date` (`date`);

--
-- Indexes for table `field`
--
ALTER TABLE `field`
  ADD PRIMARY KEY (`id_field`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id_payment`),
  ADD KEY `id_booking` (`id_booking`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id_booking` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `field`
--
ALTER TABLE `field`
  MODIFY `id_field` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `id_payment` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`id_field`) REFERENCES `field` (`id_field`),
  ADD CONSTRAINT `admin_ibfk_2` FOREIGN KEY (`id_payment`) REFERENCES `payment` (`id_payment`);

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`),
  ADD CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`id_field`) REFERENCES `field` (`id_field`);

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
