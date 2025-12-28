-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 27, 2025 at 05:08 PM
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
-- Database: `primebuild`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `code` varchar(30) NOT NULL,
  `name` varchar(150) NOT NULL,
  `type` enum('asset','liability','equity','income','expense') NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `code`, `name`, `type`, `parent_id`, `is_system`, `status`) VALUES
(1, '1000', 'Cash in Hand', 'asset', NULL, 1, 1),
(2, '1010', 'Bank', 'asset', NULL, 1, 1),
(3, '1200', 'Accounts Receivable', 'asset', NULL, 1, 1),
(4, '1300', 'Inventory', 'asset', NULL, 1, 1),
(5, '2100', 'Accounts Payable', 'liability', NULL, 1, 1),
(6, '2200', 'VAT Payable (Output)', 'liability', NULL, 1, 1),
(7, '2210', 'VAT Receivable (Input)', 'asset', NULL, 1, 1),
(8, '4000', 'Sales Revenue', 'income', NULL, 1, 1),
(9, '5000', 'Cost of Goods Sold', 'expense', NULL, 1, 1),
(10, '6000', 'General Expenses', 'expense', NULL, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(80) NOT NULL,
  `entity` varchar(80) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `meta` longtext DEFAULT NULL,
  `ip_address` varchar(60) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colors`
--

CREATE TABLE `colors` (
  `id` int(11) NOT NULL,
  `color_name` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `colors`
--

INSERT INTO `colors` (`id`, `color_name`, `status`) VALUES
(1, 'Black', 1),
(2, 'Blue', 1);

-- --------------------------------------------------------

--
-- Table structure for table `company_profile`
--

CREATE TABLE `company_profile` (
  `id` int(11) NOT NULL,
  `company_name` varchar(200) NOT NULL,
  `trade_license_no` varchar(100) DEFAULT NULL,
  `vat_trn` varchar(50) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `company_profile`
--

INSERT INTO `company_profile` (`id`, `company_name`, `trade_license_no`, `vat_trn`, `phone`, `email`, `address`, `city`, `country`, `logo_path`, `created_at`, `updated_at`) VALUES
(1, 'Primebuild', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-12-24 11:14:58', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(150) NOT NULL,
  `mobile` varchar(30) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `opening_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `current_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `customer_name`, `mobile`, `email`, `city`, `address`, `opening_balance`, `current_balance`, `status`, `created_at`, `updated_at`) VALUES
(1, 'test customer 1', '0521531217', 'test@gmail.com', 'Sharjah', 'test address', 0.00, 0.00, 1, '2025-12-24 15:35:59', '2025-12-26 00:28:29'),
(3, 'first customer', '99997', 'test@gmail.com', 'dubai', '', 0.00, 0.00, 1, '2025-12-24 16:02:36', '2025-12-26 00:28:11'),
(4, 'sadheer shah', '878978', '', 'dubai', '', 0.00, 0.00, 1, '2025-12-24 16:22:12', '2025-12-26 00:53:13'),
(5, 'shah g', '5464654', '', '', '', 0.00, 0.00, 1, '2025-12-25 23:29:28', '2025-12-26 00:17:48'),
(6, 'Modern Fitout Technical Service', '0544978496', 'asdf@gmail.com', 'Dubai', 'Sharjah', 0.00, -117.12, 1, '2025-12-27 18:57:56', '2025-12-27 19:58:07');

-- --------------------------------------------------------

--
-- Table structure for table `customer_payments`
--

CREATE TABLE `customer_payments` (
  `id` bigint(20) NOT NULL,
  `payment_no` varchar(50) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `method_id` int(11) NOT NULL,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `reference` varchar(80) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_payment_allocations`
--

CREATE TABLE `customer_payment_allocations` (
  `id` bigint(20) NOT NULL,
  `payment_id` bigint(20) NOT NULL,
  `tax_invoice_id` int(11) NOT NULL,
  `amount_alloc` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deliveries`
--

CREATE TABLE `deliveries` (
  `id` int(11) NOT NULL,
  `delivery_no` varchar(50) NOT NULL,
  `tax_invoice_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `delivery_date` date NOT NULL,
  `vehicle_no` varchar(50) DEFAULT NULL,
  `driver_name` varchar(120) DEFAULT NULL,
  `receiver_name` varchar(120) DEFAULT NULL,
  `receiver_phone` varchar(30) DEFAULT NULL,
  `delivery_address` text DEFAULT NULL,
  `status` enum('pending','partial','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_items`
--

CREATE TABLE `delivery_items` (
  `id` bigint(20) NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `sales_doc_item_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `input_unit_id` int(11) NOT NULL,
  `qty_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) NOT NULL,
  `expense_no` varchar(50) NOT NULL,
  `expense_date` date NOT NULL,
  `category_id` int(11) NOT NULL,
  `method_id` int(11) NOT NULL,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` int(11) NOT NULL,
  `category_name` varchar(120) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expense_categories`
--

INSERT INTO `expense_categories` (`id`, `category_name`, `status`) VALUES
(1, 'Rent', 1),
(2, 'Salary', 1),
(3, 'Advance', 1);

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `color_id` int(11) DEFAULT NULL,
  `size_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `base_unit_id` int(11) NOT NULL,
  `sale_mode` enum('box','piece') NOT NULL DEFAULT 'box',
  `sku` varchar(80) DEFAULT NULL,
  `barcode` varchar(80) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `sqm_per_box` decimal(12,4) DEFAULT NULL,
  `pcs_per_box` int(11) NOT NULL DEFAULT 0,
  `sqm_per_piece` decimal(12,4) DEFAULT NULL,
  `boxes_per_pallet` decimal(12,4) DEFAULT NULL,
  `pcs_per_pallet` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`id`, `item_name`, `color_id`, `size_id`, `unit_id`, `base_unit_id`, `sale_mode`, `sku`, `barcode`, `description`, `status`, `created_at`, `updated_at`, `sqm_per_box`, `pcs_per_box`, `sqm_per_piece`, `boxes_per_pallet`, `pcs_per_pallet`) VALUES
(7, 'CARRARA BLANCO 60X120', 2, 2, 5, 5, 'box', NULL, NULL, NULL, 1, '2025-12-24 16:41:42', '2025-12-25 19:23:24', 1.4400, 2, 0.0000, 25.0000, 0),
(8, 'TESSINO IVORY PULIDO 120X260', 1, 4, 5, 5, 'piece', NULL, NULL, NULL, 1, '2025-12-24 16:42:28', '2025-12-25 19:51:09', 0.0000, 0, 3.1200, 0.0000, 12),
(10, 'BLACK PULIDO 60X120', 1, 2, 5, 5, 'box', NULL, NULL, NULL, 1, '2025-12-25 17:40:19', '2025-12-25 19:23:24', 1.4400, 2, 0.0000, 50.0000, 0),
(11, 'POLISHED 160X320', 2, 5, 5, 5, 'piece', NULL, NULL, NULL, 1, '2025-12-25 18:16:34', '2025-12-25 19:50:19', 0.0000, 0, 5.1200, 0.0000, 12),
(12, 'TEST SLAB 160X320', 1, 5, 5, 5, 'piece', NULL, NULL, NULL, 1, '2025-12-25 19:41:40', NULL, 0.0000, 0, 5.0000, 0.0000, 12),
(13, 'TEST ITEM BOX 60X120', 1, 4, 5, 5, 'box', NULL, NULL, NULL, 1, '2025-12-25 19:42:27', NULL, 1.4400, 2, 0.0000, 40.0000, 0);

-- --------------------------------------------------------

--
-- Table structure for table `item_packaging`
--

CREATE TABLE `item_packaging` (
  `item_id` int(11) NOT NULL,
  `pcs_per_box` int(11) DEFAULT NULL,
  `sqm_per_box` decimal(18,4) DEFAULT NULL,
  `boxes_per_pallet` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `journal_entries`
--

CREATE TABLE `journal_entries` (
  `id` bigint(20) NOT NULL,
  `entry_no` varchar(50) NOT NULL,
  `entry_date` date NOT NULL,
  `ref_type` varchar(50) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `journal_lines`
--

CREATE TABLE `journal_lines` (
  `id` bigint(20) NOT NULL,
  `entry_id` bigint(20) NOT NULL,
  `account_id` int(11) NOT NULL,
  `debit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `credit` decimal(18,2) NOT NULL DEFAULT 0.00,
  `customer_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `memo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL,
  `method_name` varchar(80) NOT NULL,
  `method_type` enum('cash','bank','card','cheque','online','other') NOT NULL DEFAULT 'cash',
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`id`, `method_name`, `method_type`, `status`) VALUES
(1, 'Cash', 'cash', 1),
(2, 'Bank', 'bank', 1),
(4, 'Tabby', 'cash', 1),
(5, 'Card', 'cash', 1),
(6, 'Credit', 'cash', 1);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `module` varchar(80) NOT NULL,
  `action` varchar(30) NOT NULL,
  `code` varchar(150) NOT NULL,
  `label` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `module`, `action`, `code`, `label`, `created_at`) VALUES
(1, 'customers', 'view', 'customers.view', 'Customers - View', '2025-12-24 11:14:58'),
(2, 'customers', 'add', 'customers.add', 'Customers - Add', '2025-12-24 11:14:58'),
(3, 'customers', 'edit', 'customers.edit', 'Customers - Edit/Update', '2025-12-24 11:14:58'),
(4, 'customers', 'delete', 'customers.delete', 'Customers - Delete', '2025-12-24 11:14:58'),
(5, 'customers', 'print', 'customers.print', 'Customers - Print', '2025-12-24 11:14:58'),
(6, 'customers', 'export', 'customers.export', 'Customers - Export', '2025-12-24 11:14:58'),
(7, 'suppliers', 'view', 'suppliers.view', 'Suppliers - View', '2025-12-24 11:14:58'),
(8, 'suppliers', 'add', 'suppliers.add', 'Suppliers - Add', '2025-12-24 11:14:58'),
(9, 'suppliers', 'edit', 'suppliers.edit', 'Suppliers - Edit/Update', '2025-12-24 11:14:58'),
(10, 'suppliers', 'delete', 'suppliers.delete', 'Suppliers - Delete', '2025-12-24 11:14:58'),
(11, 'suppliers', 'print', 'suppliers.print', 'Suppliers - Print', '2025-12-24 11:14:58'),
(12, 'suppliers', 'export', 'suppliers.export', 'Suppliers - Export', '2025-12-24 11:14:58'),
(13, 'items', 'view', 'items.view', 'Items - View', '2025-12-24 11:14:58'),
(14, 'items', 'add', 'items.add', 'Items - Add', '2025-12-24 11:14:58'),
(15, 'items', 'edit', 'items.edit', 'Items - Edit/Update', '2025-12-24 11:14:58'),
(16, 'items', 'delete', 'items.delete', 'Items - Delete', '2025-12-24 11:14:58'),
(17, 'items', 'print', 'items.print', 'Items - Print', '2025-12-24 11:14:58'),
(18, 'items', 'export', 'items.export', 'Items - Export', '2025-12-24 11:14:58'),
(19, 'purchases', 'view', 'purchases.view', 'Purchases - View', '2025-12-24 11:14:58'),
(20, 'purchases', 'add', 'purchases.add', 'Purchases - Add', '2025-12-24 11:14:58'),
(21, 'purchases', 'edit', 'purchases.edit', 'Purchases - Edit/Update', '2025-12-24 11:14:58'),
(22, 'purchases', 'delete', 'purchases.delete', 'Purchases - Delete', '2025-12-24 11:14:58'),
(23, 'purchases', 'print', 'purchases.print', 'Purchases - Print', '2025-12-24 11:14:58'),
(24, 'purchases', 'export', 'purchases.export', 'Purchases - Export', '2025-12-24 11:14:58'),
(25, 'purchase_returns', 'view', 'purchase_returns.view', 'Purchase Returns - View', '2025-12-24 11:14:58'),
(26, 'purchase_returns', 'add', 'purchase_returns.add', 'Purchase Returns - Add', '2025-12-24 11:14:58'),
(27, 'purchase_returns', 'edit', 'purchase_returns.edit', 'Purchase Returns - Edit/Update', '2025-12-24 11:14:58'),
(28, 'purchase_returns', 'delete', 'purchase_returns.delete', 'Purchase Returns - Delete', '2025-12-24 11:14:58'),
(29, 'purchase_returns', 'print', 'purchase_returns.print', 'Purchase Returns - Print', '2025-12-24 11:14:58'),
(30, 'purchase_returns', 'export', 'purchase_returns.export', 'Purchase Returns - Export', '2025-12-24 11:14:58'),
(31, 'sales', 'view', 'sales.view', 'Sales - View', '2025-12-24 11:14:58'),
(32, 'sales', 'add', 'sales.add', 'Sales - Add', '2025-12-24 11:14:58'),
(33, 'sales', 'edit', 'sales.edit', 'Sales - Edit/Update', '2025-12-24 11:14:58'),
(34, 'sales', 'delete', 'sales.delete', 'Sales - Delete', '2025-12-24 11:14:58'),
(35, 'sales', 'print', 'sales.print', 'Sales - Print', '2025-12-24 11:14:58'),
(36, 'sales', 'export', 'sales.export', 'Sales - Export', '2025-12-24 11:14:58'),
(37, 'sales_returns', 'view', 'sales_returns.view', 'Sales Returns - View', '2025-12-24 11:14:58'),
(38, 'sales_returns', 'add', 'sales_returns.add', 'Sales Returns - Add', '2025-12-24 11:14:58'),
(39, 'sales_returns', 'edit', 'sales_returns.edit', 'Sales Returns - Edit/Update', '2025-12-24 11:14:58'),
(40, 'sales_returns', 'delete', 'sales_returns.delete', 'Sales Returns - Delete', '2025-12-24 11:14:58'),
(41, 'sales_returns', 'print', 'sales_returns.print', 'Sales Returns - Print', '2025-12-24 11:14:58'),
(42, 'sales_returns', 'export', 'sales_returns.export', 'Sales Returns - Export', '2025-12-24 11:14:58'),
(43, 'deliveries', 'view', 'deliveries.view', 'Deliveries - View', '2025-12-24 11:14:58'),
(44, 'deliveries', 'add', 'deliveries.add', 'Deliveries - Add', '2025-12-24 11:14:58'),
(45, 'deliveries', 'edit', 'deliveries.edit', 'Deliveries - Edit/Update', '2025-12-24 11:14:58'),
(46, 'deliveries', 'delete', 'deliveries.delete', 'Deliveries - Delete', '2025-12-24 11:14:58'),
(47, 'deliveries', 'print', 'deliveries.print', 'Deliveries - Print', '2025-12-24 11:14:58'),
(48, 'deliveries', 'export', 'deliveries.export', 'Deliveries - Export', '2025-12-24 11:14:58'),
(49, 'utilities', 'view', 'utilities.view', 'Utilities - View', '2025-12-24 11:14:58'),
(50, 'utilities', 'add', 'utilities.add', 'Utilities - Add', '2025-12-24 11:14:58'),
(51, 'utilities', 'edit', 'utilities.edit', 'Utilities - Edit/Update', '2025-12-24 11:14:58'),
(52, 'utilities', 'delete', 'utilities.delete', 'Utilities - Delete', '2025-12-24 11:14:58'),
(53, 'utilities', 'print', 'utilities.print', 'Utilities - Print', '2025-12-24 11:14:58'),
(54, 'utilities', 'export', 'utilities.export', 'Utilities - Export', '2025-12-24 11:14:58'),
(55, 'payments', 'view', 'payments.view', 'Payments - View', '2025-12-24 11:14:58'),
(56, 'payments', 'add', 'payments.add', 'Payments - Add', '2025-12-24 11:14:58'),
(57, 'payments', 'edit', 'payments.edit', 'Payments - Edit/Update', '2025-12-24 11:14:58'),
(58, 'payments', 'delete', 'payments.delete', 'Payments - Delete', '2025-12-24 11:14:58'),
(59, 'payments', 'print', 'payments.print', 'Payments - Print', '2025-12-24 11:14:58'),
(60, 'payments', 'export', 'payments.export', 'Payments - Export', '2025-12-24 11:14:58'),
(61, 'stock', 'view', 'stock.view', 'Stock - View', '2025-12-24 11:14:58'),
(62, 'stock', 'add', 'stock.add', 'Stock - Add/Adjust', '2025-12-24 11:14:58'),
(63, 'stock', 'edit', 'stock.edit', 'Stock - Edit/Update', '2025-12-24 11:14:58'),
(64, 'stock', 'delete', 'stock.delete', 'Stock - Delete', '2025-12-24 11:14:58'),
(65, 'stock', 'print', 'stock.print', 'Stock - Print', '2025-12-24 11:14:58'),
(66, 'stock', 'export', 'stock.export', 'Stock - Export', '2025-12-24 11:14:58'),
(67, 'expenses', 'view', 'expenses.view', 'Expenses - View', '2025-12-24 11:14:58'),
(68, 'expenses', 'add', 'expenses.add', 'Expenses - Add', '2025-12-24 11:14:58'),
(69, 'expenses', 'edit', 'expenses.edit', 'Expenses - Edit/Update', '2025-12-24 11:14:58'),
(70, 'expenses', 'delete', 'expenses.delete', 'Expenses - Delete', '2025-12-24 11:14:58'),
(71, 'expenses', 'print', 'expenses.print', 'Expenses - Print', '2025-12-24 11:14:58'),
(72, 'expenses', 'export', 'expenses.export', 'Expenses - Export', '2025-12-24 11:14:58'),
(73, 'reports', 'view', 'reports.view', 'Reports - View', '2025-12-24 11:14:58'),
(74, 'reports', 'add', 'reports.add', 'Reports - Add (if any)', '2025-12-24 11:14:58'),
(75, 'reports', 'edit', 'reports.edit', 'Reports - Edit/Update', '2025-12-24 11:14:58'),
(76, 'reports', 'delete', 'reports.delete', 'Reports - Delete', '2025-12-24 11:14:58'),
(77, 'reports', 'print', 'reports.print', 'Reports - Print', '2025-12-24 11:14:58'),
(78, 'reports', 'export', 'reports.export', 'Reports - Export', '2025-12-24 11:14:58'),
(79, 'settings', 'view', 'settings.view', 'Settings - View', '2025-12-24 11:14:58'),
(80, 'settings', 'add', 'settings.add', 'Settings - Add', '2025-12-24 11:14:58'),
(81, 'settings', 'edit', 'settings.edit', 'Settings - Edit/Update', '2025-12-24 11:14:58'),
(82, 'settings', 'delete', 'settings.delete', 'Settings - Delete', '2025-12-24 11:14:58'),
(83, 'settings', 'print', 'settings.print', 'Settings - Print', '2025-12-24 11:14:58'),
(84, 'settings', 'export', 'settings.export', 'Settings - Export', '2025-12-24 11:14:58'),
(85, 'rbac', 'view', 'rbac.view', 'Roles & Permissions - View', '2025-12-24 11:14:58'),
(86, 'rbac', 'add', 'rbac.add', 'Roles & Permissions - Add', '2025-12-24 11:14:58'),
(87, 'rbac', 'edit', 'rbac.edit', 'Roles & Permissions - Edit/Update', '2025-12-24 11:14:58'),
(88, 'rbac', 'delete', 'rbac.delete', 'Roles & Permissions - Delete', '2025-12-24 11:14:58'),
(89, 'rbac', 'print', 'rbac.print', 'Roles & Permissions - Print', '2025-12-24 11:14:58'),
(90, 'rbac', 'export', 'rbac.export', 'Roles & Permissions - Export', '2025-12-24 11:14:58'),
(91, 'dashboard', 'view', 'dashboard.view', 'Dashboard - View', '2025-12-24 11:14:58'),
(92, 'dashboard', 'add', 'dashboard.add', 'Dashboard - Add', '2025-12-24 11:14:58'),
(93, 'dashboard', 'edit', 'dashboard.edit', 'Dashboard - Edit/Update', '2025-12-24 11:14:58'),
(94, 'dashboard', 'delete', 'dashboard.delete', 'Dashboard - Delete', '2025-12-24 11:14:58'),
(95, 'dashboard', 'print', 'dashboard.print', 'Dashboard - Print', '2025-12-24 11:14:58'),
(96, 'dashboard', 'export', 'dashboard.export', 'Dashboard - Export', '2025-12-24 11:14:58');

-- --------------------------------------------------------

--
-- Table structure for table `petty_cash_entries`
--

CREATE TABLE `petty_cash_entries` (
  `id` bigint(20) NOT NULL,
  `entry_date` date NOT NULL,
  `direction` enum('in','out') NOT NULL,
  `method_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `description` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `ref_type` varchar(30) DEFAULT NULL,
  `ref_id` int(11) DEFAULT NULL,
  `is_auto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `petty_cash_entries`
--

INSERT INTO `petty_cash_entries` (`id`, `entry_date`, `direction`, `method_id`, `category_id`, `amount`, `description`, `created_by`, `created_at`, `ref_type`, `ref_id`, `is_auto`) VALUES
(1, '2025-12-24', 'out', 1, NULL, 12000.00, 'Supplier payment for PUR-000001', 1, '2025-12-24 20:12:01', NULL, NULL, 0),
(2, '2025-12-24', 'out', 1, NULL, 9000.00, 'Supplier payment for PUR-000002', 1, '2025-12-24 20:12:44', NULL, NULL, 0),
(3, '2025-12-24', 'out', 5, NULL, 74000.00, 'Supplier payment for PUR-000003', 1, '2025-12-24 20:32:26', NULL, NULL, 0),
(4, '2025-12-24', 'out', 5, NULL, 18000.00, 'Supplier payment for PUR-000004', 1, '2025-12-24 20:37:22', NULL, NULL, 0),
(5, '2025-12-24', 'out', 2, NULL, 10500.00, 'Supplier payment for PUR-000006', 1, '2025-12-24 23:06:27', NULL, NULL, 0),
(7, '2025-12-24', 'out', 2, NULL, 12000.00, 'Supplier payment for PUR-000005', 1, '2025-12-24 23:35:15', NULL, NULL, 0),
(9, '2025-12-24', 'out', 2, NULL, 6025.00, 'Supplier payment for PUR-000008', 1, '2025-12-24 23:39:10', NULL, NULL, 0),
(11, '2025-12-24', 'out', 1, NULL, 1000.00, 'Supplier payment for PUR-000007', 1, '2025-12-24 23:48:56', NULL, NULL, 0),
(12, '2025-12-25', 'out', 1, NULL, 1000.00, 'Supplier payment for PUR-000009', 1, '2025-12-25 01:03:28', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` int(11) NOT NULL,
  `purchase_no` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `purchase_date` date NOT NULL,
  `reference_no` varchar(80) DEFAULT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `status` enum('draft','posted','cancelled') NOT NULL DEFAULT 'posted',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `supplier_invoice_no` varchar(50) DEFAULT NULL,
  `paid_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `balance_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `payment_method_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `purchase_no`, `supplier_id`, `purchase_date`, `reference_no`, `subtotal`, `discount`, `vat_rate`, `vat_amount`, `total_amount`, `notes`, `status`, `created_by`, `created_at`, `updated_at`, `supplier_invoice_no`, `paid_amount`, `balance_amount`, `payment_method_id`) VALUES
(8, 'PR-000008', 2, '2025-12-24', NULL, 0.00, 0.00, 0.00, 0.00, 2000.00, 'asdfasdf', 'posted', NULL, '2025-12-24 18:54:09', '2025-12-24 18:54:09', '234324', 500.00, 0.00, NULL),
(9, 'PR-000009', 1, '2025-12-24', NULL, 0.00, 0.00, 0.00, 0.00, 15000.00, 'asfsad', 'posted', NULL, '2025-12-24 19:00:03', '2025-12-24 19:00:03', '23432', 8000.00, 0.00, 1),
(13, 'PUR-000001', 2, '2025-12-24', '234', 11520.00, 0.00, 5.00, 576.00, 12096.00, 'asdf', 'posted', 1, '2025-12-24 20:12:01', NULL, '234', 12000.00, 96.00, 1),
(14, 'PUR-000002', 1, '2025-12-24', '2343', 8640.00, 0.00, 5.00, 432.00, 9072.00, 'asdf', 'posted', 1, '2025-12-24 20:12:44', NULL, '2343', 9000.00, 72.00, 1),
(15, 'PUR-000003', 1, '2025-12-24', '', 70638.00, 0.00, 5.00, 3531.90, 70638.00, '', 'posted', 1, '2025-12-24 20:32:26', '2025-12-24 20:34:10', '3334444', 70638.00, 0.00, 5),
(16, 'PUR-000004', 4, '2025-12-24', '251322', 17505.00, 0.00, 5.00, 875.25, 17505.00, 'sfasdf', 'posted', 1, '2025-12-24 20:37:22', '2025-12-24 20:37:59', '251322', 17505.00, 0.00, 5),
(17, 'PUR-000005', 4, '2025-12-24', '221133', 12247.50, 0.00, 0.00, 0.00, 12247.50, 'Test purchase', 'posted', 1, '2025-12-24 20:39:53', '2025-12-24 23:35:15', '221133', 12000.00, 247.50, 2),
(18, 'PUR-000006', 4, '2025-12-24', '1234567', 102240.00, 0.00, 0.00, 0.00, 102240.00, 'Took Barrow for temporary as loan', 'posted', 1, '2025-12-24 23:06:27', '2025-12-24 23:19:45', '1234567', 12500.00, 89740.00, 4),
(19, 'PUR-000007', 4, '2025-12-24', '234323423', 1200.00, 0.00, 0.00, 0.00, 1200.00, 'Confirm Vat', 'posted', 1, '2025-12-24 23:38:12', '2025-12-24 23:48:56', '234323423', 1000.00, 200.00, 1),
(20, 'PUR-000008', 1, '2025-12-24', '12312', 6500.00, 0.00, 5.00, 325.00, 6825.00, 'asdfsdf', 'posted', 1, '2025-12-24 23:39:10', NULL, '12312', 6025.00, 800.00, 2),
(21, 'PUR-000009', 5, '2025-12-25', '111122222', 1152.00, 0.00, 5.00, 0.00, 1152.00, '', 'posted', 1, '2025-12-25 01:03:28', '2025-12-25 02:35:39', '111122222', 1000.00, 152.00, 1),
(22, 'PUR-000010', 4, '2025-12-25', '23434', 18000.00, 0.00, 5.00, 900.00, 18900.00, '', 'posted', 1, '2025-12-25 17:41:00', NULL, '23434', 0.00, 18900.00, NULL),
(23, 'PUR-000011', 4, '2025-12-25', '', 5529.60, 0.00, 5.00, 276.48, 5806.08, '', 'posted', 1, '2025-12-25 18:17:46', NULL, '', 0.00, 5806.08, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `input_unit_id` int(11) NOT NULL,
  `qty_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_cost_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_cost_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `line_subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `unit_id` int(11) DEFAULT NULL,
  `price_per_unit` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `price_per_sqm` decimal(12,4) NOT NULL DEFAULT 0.0000,
  `sqm_per_box` decimal(12,4) DEFAULT NULL,
  `pcs_per_box` int(11) DEFAULT NULL,
  `boxes_per_pallet` decimal(12,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`id`, `purchase_id`, `item_id`, `input_unit_id`, `qty_input`, `qty_sqm`, `qty_boxes`, `qty_pallets`, `qty_pcs`, `unit_cost_input`, `unit_cost_sqm`, `line_subtotal`, `vat_rate`, `vat_amount`, `line_total`, `unit_id`, `price_per_unit`, `price_per_sqm`, `sqm_per_box`, `pcs_per_box`, `boxes_per_pallet`) VALUES
(6, 8, 7, 5, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.00, 0.00, 0.00, 0.00, 5, 0.0000, 0.0000, NULL, NULL, NULL),
(7, 9, 8, 5, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.00, 0.00, 0.00, 0.00, 5, 0.0000, 0.0000, NULL, NULL, NULL),
(8, 13, 7, 5, 230.4000, 230.4000, 160.0000, 4.0000, 0.0000, 50.0000, 50.0000, 11520.00, 5.00, 576.00, 12096.00, 5, 50.0000, 50.0000, 1.4400, 0, 40.0000),
(9, 14, 8, 5, 288.0000, 288.0000, 200.0000, 5.0000, 0.0000, 30.0000, 30.0000, 8640.00, 5.00, 432.00, 9072.00, 5, 30.0000, 30.0000, 1.4400, 0, 40.0000),
(13, 15, 8, 5, 115.2000, 0.0000, 0.0000, 0.0000, 0.0000, 80.0000, 0.0000, 9216.00, 0.00, 0.00, 9216.00, NULL, 0.0000, 0.0000, NULL, NULL, NULL),
(14, 15, 8, 5, 460.8000, 0.0000, 0.0000, 0.0000, 0.0000, 90.0000, 0.0000, 41472.00, 0.00, 0.00, 41472.00, NULL, 0.0000, 0.0000, NULL, NULL, NULL),
(15, 15, 7, 5, 399.0000, 0.0000, 0.0000, 0.0000, 0.0000, 50.0000, 0.0000, 19950.00, 0.00, 0.00, 19950.00, NULL, 0.0000, 0.0000, NULL, NULL, NULL),
(18, 16, 8, 5, 576.0000, 0.0000, 0.0000, 0.0000, 0.0000, 20.0000, 0.0000, 11520.00, 0.00, 0.00, 11520.00, NULL, 0.0000, 0.0000, NULL, NULL, NULL),
(19, 16, 7, 5, 598.5000, 0.0000, 0.0000, 0.0000, 0.0000, 10.0000, 0.0000, 5985.00, 0.00, 0.00, 5985.00, NULL, 0.0000, 0.0000, NULL, NULL, NULL),
(27, 18, 7, 5, 1555.2000, 1555.2000, 1080.0000, 30.0000, 0.0000, 25.0000, 25.0000, 38880.00, 0.00, 0.00, 38880.00, 5, 25.0000, 25.0000, 1.4400, 0, 36.0000),
(28, 18, 8, 5, 1152.0000, 1152.0000, 450.0000, 30.0000, 0.0000, 55.0000, 55.0000, 63360.00, 0.00, 0.00, 63360.00, 5, 55.0000, 55.0000, 2.5600, 0, 15.0000),
(32, 17, 8, 5, 432.0000, 432.0000, 300.0000, 15.0000, 0.0000, 15.0000, 15.0000, 6480.00, 0.00, 0.00, 6480.00, 5, 15.0000, 15.0000, 1.4400, 0, 20.0000),
(33, 17, 7, 5, 225.0000, 225.0000, 180.0000, 12.0000, 0.0000, 16.0000, 16.0000, 3600.00, 0.00, 0.00, 3600.00, 5, 16.0000, 16.0000, 1.2500, 0, 15.0000),
(34, 17, 7, 5, 127.5000, 127.5000, 50.0000, 5.0000, 0.0000, 17.0000, 17.0000, 2167.50, 0.00, 0.00, 2167.50, 5, 17.0000, 17.0000, 2.5500, 0, 10.0000),
(36, 20, 7, 5, 260.0000, 260.0000, 100.0000, 10.0000, 0.0000, 25.0000, 25.0000, 6500.00, 5.00, 325.00, 6825.00, 5, 25.0000, 25.0000, 2.6000, 0, 10.0000),
(38, 19, 7, 5, 48.0000, 48.0000, 30.0000, 3.0000, 0.0000, 25.0000, 25.0000, 1200.00, 0.00, 0.00, 1200.00, 5, 25.0000, 25.0000, 1.6000, 0, 10.0000),
(39, 21, 7, 5, 72.0000, 72.0000, 50.0000, 2.0000, 0.0000, 16.0000, 16.0000, 1152.00, 0.00, 0.00, 1152.00, 5, 16.0000, 16.0000, 1.4400, 0, 25.0000),
(40, 22, 10, 5, 720.0000, 720.0000, 500.0000, 10.0000, 0.0000, 25.0000, 25.0000, 18000.00, 5.00, 900.00, 18900.00, 5, 25.0000, 25.0000, 1.4400, 0, 50.0000),
(41, 23, 11, 5, 61.4400, 61.4400, 1.0000, 1.0000, 0.0000, 90.0000, 90.0000, 5529.60, 5.00, 276.48, 5806.08, 5, 90.0000, 90.0000, 61.4400, 0, 1.0000);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_returns`
--

CREATE TABLE `purchase_returns` (
  `id` int(11) NOT NULL,
  `return_no` varchar(50) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `return_date` date NOT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `refund_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `refund_method_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('draft','posted','cancelled') NOT NULL DEFAULT 'posted',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_return_items`
--

CREATE TABLE `purchase_return_items` (
  `id` bigint(20) NOT NULL,
  `return_id` int(11) NOT NULL,
  `purchase_item_id` bigint(20) DEFAULT NULL,
  `item_id` int(11) NOT NULL,
  `input_unit_id` int(11) NOT NULL,
  `qty_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_cost_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`, `is_system`, `created_at`) VALUES
(1, 'Super Admin', 1, '2025-12-24 11:14:58');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(1, 20),
(1, 21),
(1, 22),
(1, 23),
(1, 24),
(1, 25),
(1, 26),
(1, 27),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 34),
(1, 35),
(1, 36),
(1, 37),
(1, 38),
(1, 39),
(1, 40),
(1, 41),
(1, 42),
(1, 43),
(1, 44),
(1, 45),
(1, 46),
(1, 47),
(1, 48),
(1, 49),
(1, 50),
(1, 51),
(1, 52),
(1, 53),
(1, 54),
(1, 55),
(1, 56),
(1, 57),
(1, 58),
(1, 59),
(1, 60),
(1, 61),
(1, 62),
(1, 63),
(1, 64),
(1, 65),
(1, 66),
(1, 67),
(1, 68),
(1, 69),
(1, 70),
(1, 71),
(1, 72),
(1, 73),
(1, 74),
(1, 75),
(1, 76),
(1, 77),
(1, 78),
(1, 79),
(1, 80),
(1, 81),
(1, 82),
(1, 83),
(1, 84),
(1, 85),
(1, 86),
(1, 87),
(1, 88),
(1, 89),
(1, 90),
(1, 91),
(1, 92),
(1, 93),
(1, 94),
(1, 95),
(1, 96);

-- --------------------------------------------------------

--
-- Table structure for table `sales_docs`
--

CREATE TABLE `sales_docs` (
  `id` int(11) NOT NULL,
  `doc_no` varchar(50) NOT NULL,
  `doc_type` enum('quotation','proforma','tax_invoice') NOT NULL,
  `customer_id` int(11) NOT NULL,
  `doc_date` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `source_doc_id` int(11) DEFAULT NULL,
  `reserve_stock` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('draft','confirmed','cancelled') NOT NULL DEFAULT 'confirmed',
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `balance_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `payment_method_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_docs`
--

INSERT INTO `sales_docs` (`id`, `doc_no`, `doc_type`, `customer_id`, `doc_date`, `valid_until`, `source_doc_id`, `reserve_stock`, `status`, `subtotal`, `discount`, `vat_rate`, `vat_amount`, `total_amount`, `paid_amount`, `balance_amount`, `payment_method_id`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(38, 'QT-000038', 'quotation', 4, '2025-12-26', NULL, NULL, 0, 'draft', 0.00, 0.00, 5.00, 0.00, 0.00, 0.00, 0.00, 2, '', 1, '2025-12-26 00:33:28', '2025-12-26 00:33:28'),
(39, 'PI-000039', 'proforma', 4, '2025-12-26', NULL, NULL, 0, 'draft', 0.00, 0.00, 5.00, 0.00, 0.00, 0.00, 0.00, 2, '', 1, '2025-12-26 00:36:08', '2025-12-26 00:36:08'),
(40, 'PI-000040', 'proforma', 4, '2025-12-26', NULL, NULL, 0, 'confirmed', 24.48, 0.00, 5.00, 1.22, 25.70, 0.00, 25.70, 2, '', 1, '2025-12-26 00:38:09', '2025-12-26 00:39:04'),
(44, 'PI-000044', 'proforma', 4, '2025-12-26', NULL, NULL, 0, 'confirmed', 86.40, 0.00, 5.00, 4.32, 90.72, 0.00, 90.72, 2, '', 1, '2025-12-26 00:54:55', '2025-12-26 00:56:34'),
(45, 'SAL-000045', 'tax_invoice', 6, '2025-12-27', NULL, NULL, 0, 'confirmed', 362.88, 0.00, 0.00, 0.00, 362.88, 300.00, 62.88, 2, '', 1, '2025-12-27 19:00:02', '2025-12-27 19:00:02');

-- --------------------------------------------------------

--
-- Table structure for table `sales_doc_items`
--

CREATE TABLE `sales_doc_items` (
  `id` bigint(20) NOT NULL,
  `sales_doc_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `input_unit_id` int(11) NOT NULL,
  `qty_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_price_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_price_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `line_subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_rate` decimal(5,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_doc_items`
--

INSERT INTO `sales_doc_items` (`id`, `sales_doc_id`, `item_id`, `input_unit_id`, `qty_input`, `qty_sqm`, `qty_boxes`, `qty_pallets`, `qty_pcs`, `unit_price_input`, `unit_price_sqm`, `line_subtotal`, `vat_rate`, `vat_amount`, `line_total`) VALUES
(31, 40, 7, 5, 1.4400, 1.4400, 1.0000, 0.0000, 2.0000, 17.0000, 17.0000, 24.48, 5.00, 1.22, 25.70),
(39, 44, 10, 5, 2.8800, 2.8800, 2.0000, 0.0000, 4.0000, 30.0000, 30.0000, 86.40, 5.00, 4.32, 90.72),
(40, 45, 7, 5, 20.1600, 20.1600, 14.0000, 0.0000, 28.0000, 18.0000, 18.0000, 362.88, 0.00, 0.00, 362.88);

-- --------------------------------------------------------

--
-- Table structure for table `sales_item_allocations`
--

CREATE TABLE `sales_item_allocations` (
  `id` bigint(20) NOT NULL,
  `source_item_id` bigint(20) NOT NULL,
  `target_item_id` bigint(20) NOT NULL,
  `qty_sqm_alloc` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sales_returns`
--

CREATE TABLE `sales_returns` (
  `id` int(11) NOT NULL,
  `return_no` varchar(50) NOT NULL,
  `tax_invoice_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `return_date` date NOT NULL,
  `subtotal` decimal(18,2) NOT NULL DEFAULT 0.00,
  `vat_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `refund_amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `status` enum('draft','posted','cancelled') NOT NULL DEFAULT 'posted',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_returns`
--

INSERT INTO `sales_returns` (`id`, `return_no`, `tax_invoice_id`, `customer_id`, `return_date`, `subtotal`, `vat_amount`, `total_amount`, `refund_amount`, `notes`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(2, 'SRN-000001', 45, 6, '2025-12-27', 180.00, 0.00, 180.00, 0.00, '', 'posted', 1, '2025-12-27 19:58:07', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sales_return_items`
--

CREATE TABLE `sales_return_items` (
  `id` bigint(20) NOT NULL,
  `return_id` int(11) NOT NULL,
  `sales_doc_item_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `input_unit_id` int(11) NOT NULL,
  `qty_input` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_price_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `line_total` decimal(18,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales_return_items`
--

INSERT INTO `sales_return_items` (`id`, `return_id`, `sales_doc_item_id`, `item_id`, `input_unit_id`, `qty_input`, `qty_sqm`, `qty_boxes`, `qty_pallets`, `qty_pcs`, `unit_price_sqm`, `line_total`) VALUES
(1, 2, 40, 7, 5, 10.0000, 10.0000, 0.0000, 0.0000, 0.0000, 18.0000, 180.00);

-- --------------------------------------------------------

--
-- Table structure for table `sequences`
--

CREATE TABLE `sequences` (
  `seq_key` varchar(50) NOT NULL,
  `prefix` varchar(20) NOT NULL,
  `next_number` bigint(20) NOT NULL DEFAULT 1,
  `pad_length` int(11) NOT NULL DEFAULT 6,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sequences`
--

INSERT INTO `sequences` (`seq_key`, `prefix`, `next_number`, `pad_length`, `updated_at`) VALUES
('customer_payment', 'CRV-', 1, 6, NULL),
('delivery', 'DN-', 1, 6, NULL),
('expense', 'EXP-', 1, 6, NULL),
('journal', 'JV-', 1, 6, NULL),
('proforma', 'PI-', 1, 6, NULL),
('purchase', 'PUR-', 12, 6, '2025-12-25 18:17:46'),
('purchase_return', 'PRN-', 1, 6, NULL),
('quotation', 'QUO-', 1, 6, NULL),
('sales_return', 'SRN-', 2, 6, '2025-12-27 19:58:07'),
('stock_adjust', 'ADJ-', 1, 6, NULL),
('supplier_payment', 'SPV-', 9, 6, '2025-12-25 01:03:28'),
('tax_invoice', 'TINV-', 1, 6, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `sizes`
--

CREATE TABLE `sizes` (
  `id` int(11) NOT NULL,
  `size_name` varchar(100) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sizes`
--

INSERT INTO `sizes` (`id`, `size_name`, `status`) VALUES
(1, '80x160', 1),
(2, '60x120', 1),
(4, '120x260', 1),
(5, '160X320', 1);

-- --------------------------------------------------------

--
-- Table structure for table `stock_adjustments`
--

CREATE TABLE `stock_adjustments` (
  `id` int(11) NOT NULL,
  `adjustment_no` varchar(50) NOT NULL,
  `adjustment_date` date NOT NULL,
  `adj_type` enum('increase','decrease') NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_adjustment_items`
--

CREATE TABLE `stock_adjustment_items` (
  `id` bigint(20) NOT NULL,
  `adjustment_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_cost_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stock_ledger`
--

CREATE TABLE `stock_ledger` (
  `id` bigint(20) NOT NULL,
  `tx_date` date NOT NULL,
  `item_id` int(11) NOT NULL,
  `ref_type` enum('purchase','purchase_return','tax_invoice','sales_return','stock_adjust','reserve','reserve_release') NOT NULL,
  `ref_id` bigint(20) NOT NULL,
  `direction` enum('in','out') NOT NULL,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_boxes` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pallets` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `qty_pcs` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit_cost_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `note` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_ledger`
--

INSERT INTO `stock_ledger` (`id`, `tx_date`, `item_id`, `ref_type`, `ref_id`, `direction`, `qty_sqm`, `qty_boxes`, `qty_pallets`, `qty_pcs`, `unit_cost_sqm`, `note`, `created_at`) VALUES
(1, '2025-12-24', 7, 'purchase', 13, 'in', 230.4000, 160.0000, 4.0000, 0.0000, 50.0000, 'PUR-000001', '2025-12-24 20:12:01'),
(2, '2025-12-24', 8, 'purchase', 14, 'in', 288.0000, 200.0000, 5.0000, 0.0000, 30.0000, 'PUR-000002', '2025-12-24 20:12:44'),
(3, '2025-12-24', 8, 'purchase', 15, 'in', 115.2000, 80.0000, 2.0000, 0.0000, 80.0000, 'PUR-000003', '2025-12-24 20:32:26'),
(4, '2025-12-24', 8, 'purchase', 15, 'in', 460.8000, 320.0000, 4.0000, 0.0000, 90.0000, 'PUR-000003', '2025-12-24 20:32:26'),
(5, '2025-12-24', 7, 'purchase', 15, 'in', 399.0000, 300.0000, 10.0000, 0.0000, 50.0000, 'PUR-000003', '2025-12-24 20:32:26'),
(6, '2025-12-24', 8, 'purchase', 16, 'in', 576.0000, 400.0000, 10.0000, 0.0000, 20.0000, 'PUR-000004', '2025-12-24 20:37:22'),
(7, '2025-12-24', 7, 'purchase', 16, 'in', 598.5000, 450.0000, 15.0000, 0.0000, 10.0000, 'PUR-000004', '2025-12-24 20:37:22'),
(15, '2025-12-24', 7, 'purchase', 18, 'in', 1555.2000, 1080.0000, 30.0000, 0.0000, 25.0000, 'PUR-000006', '2025-12-24 23:19:45'),
(16, '2025-12-24', 8, 'purchase', 18, 'in', 1152.0000, 450.0000, 30.0000, 0.0000, 55.0000, 'PUR-000006', '2025-12-24 23:19:45'),
(20, '2025-12-24', 8, 'purchase', 17, 'in', 432.0000, 300.0000, 15.0000, 0.0000, 15.0000, 'PUR-000005', '2025-12-24 23:35:15'),
(21, '2025-12-24', 7, 'purchase', 17, 'in', 225.0000, 180.0000, 12.0000, 0.0000, 16.0000, 'PUR-000005', '2025-12-24 23:35:15'),
(22, '2025-12-24', 7, 'purchase', 17, 'in', 127.5000, 50.0000, 5.0000, 0.0000, 17.0000, 'PUR-000005', '2025-12-24 23:35:15'),
(24, '2025-12-24', 7, 'purchase', 20, 'in', 260.0000, 100.0000, 10.0000, 0.0000, 25.0000, 'PUR-000008', '2025-12-24 23:39:10'),
(26, '2025-12-24', 7, 'purchase', 19, 'in', 48.0000, 30.0000, 3.0000, 0.0000, 25.0000, 'PUR-000007', '2025-12-24 23:48:56'),
(27, '2025-12-25', 7, 'purchase', 21, 'in', 72.0000, 50.0000, 2.0000, 0.0000, 16.0000, 'PUR-000009', '2025-12-25 01:03:28'),
(33, '2025-12-25', 10, 'purchase', 22, 'in', 720.0000, 500.0000, 10.0000, 0.0000, 25.0000, 'PUR-000010', '2025-12-25 17:41:00'),
(34, '2025-12-25', 11, 'purchase', 23, 'in', 61.4400, 1.0000, 1.0000, 0.0000, 90.0000, 'PUR-000011', '2025-12-25 18:17:46'),
(55, '2025-12-27', 7, 'tax_invoice', 45, 'out', 20.1600, 14.0000, 0.0000, 28.0000, 0.0000, '', '2025-12-27 19:00:03'),
(56, '2025-12-27', 7, 'sales_return', 2, 'in', 10.0000, 0.0000, 0.0000, 0.0000, 0.0000, 'Sales return ID 2 against tax invoice 45', '2025-12-27 19:58:07');

-- --------------------------------------------------------

--
-- Table structure for table `stock_reservations`
--

CREATE TABLE `stock_reservations` (
  `id` bigint(20) NOT NULL,
  `proforma_id` int(11) NOT NULL,
  `proforma_item_id` bigint(20) NOT NULL,
  `item_id` int(11) NOT NULL,
  `qty_sqm` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `status` enum('active','released','converted','cancelled') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `supplier_name` varchar(150) NOT NULL,
  `mobile` varchar(30) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `opening_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `current_balance` decimal(18,2) NOT NULL DEFAULT 0.00,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `supplier_name`, `mobile`, `email`, `city`, `address`, `opening_balance`, `current_balance`, `status`, `created_at`, `updated_at`) VALUES
(1, 'test supplier 1', '7987897', 'test@gmail.com', 'dubai', 'dubai', 500.00, 1922.15, 1, '2025-12-24 16:28:28', '2025-12-24 23:39:10'),
(2, 'asdfasdf', '878978', 'asdfasdf@gmail.com', 'sharjah', 'asdf', 0.00, 96.00, 1, '2025-12-24 16:28:43', '2025-12-24 20:12:01'),
(4, 'Lunna Tiles', '234324', 'syed.sadheer2023@gmailc.om', 'Dubai', '3rd Street Building No 16 Room # 101 Floor 1st', 0.00, 114893.58, 1, '2025-12-24 20:36:36', '2025-12-25 18:17:46'),
(5, 'Syed', '0521531217', 'syed@gmail.com', 'Dubai', 'Al Barha Stree 10 Hor Al Anz Deira Dubai', 0.00, 152.00, 1, '2025-12-25 01:02:52', '2025-12-25 16:30:59');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_payments`
--

CREATE TABLE `supplier_payments` (
  `id` bigint(20) NOT NULL,
  `payment_no` varchar(50) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `method_id` int(11) NOT NULL,
  `amount` decimal(18,2) NOT NULL DEFAULT 0.00,
  `reference` varchar(80) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `source_purchase_id` int(11) DEFAULT NULL,
  `is_auto` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_payments`
--

INSERT INTO `supplier_payments` (`id`, `payment_no`, `supplier_id`, `payment_date`, `method_id`, `amount`, `reference`, `notes`, `created_by`, `created_at`, `source_purchase_id`, `is_auto`) VALUES
(1, 'SPV-000001', 2, '2025-12-24', 1, 12000.00, 'PUR-000001', 'Auto payment at purchase', 1, '2025-12-24 20:12:01', NULL, 0),
(2, 'SPV-000002', 1, '2025-12-24', 1, 9000.00, 'PUR-000002', 'Auto payment at purchase', 1, '2025-12-24 20:12:44', NULL, 0),
(3, 'SPV-000003', 1, '2025-12-24', 5, 74000.00, 'PUR-000003', 'Auto payment at purchase', 1, '2025-12-24 20:32:26', NULL, 0),
(4, 'SPV-000004', 1, '2025-12-24', 5, 18000.00, 'PUR-000004', 'Auto payment at purchase', 1, '2025-12-24 20:37:22', NULL, 0),
(5, 'SPV-000005', 4, '2025-12-24', 2, 10500.00, 'PUR-000006', 'Auto payment at purchase', 1, '2025-12-24 23:06:27', NULL, 0),
(7, 'SP-000007', 4, '2025-12-24', 2, 12000.00, 'PUR-000005', 'Auto payment at purchase', 1, '2025-12-24 23:35:15', NULL, 0),
(9, 'SPV-000007', 1, '2025-12-24', 2, 6025.00, 'PUR-000008', 'Auto payment at purchase', 1, '2025-12-24 23:39:10', NULL, 0),
(11, 'SP-000011', 4, '2025-12-24', 1, 1000.00, 'PUR-000007', 'Auto payment at purchase', 1, '2025-12-24 23:48:56', NULL, 0),
(12, 'SPV-000008', 5, '2025-12-25', 1, 1000.00, 'PUR-000009', 'Auto payment at purchase', 1, '2025-12-25 01:03:28', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `supplier_payment_allocations`
--

CREATE TABLE `supplier_payment_allocations` (
  `id` bigint(20) NOT NULL,
  `payment_id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `amount_alloc` decimal(18,2) NOT NULL DEFAULT 0.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `supplier_payment_allocations`
--

INSERT INTO `supplier_payment_allocations` (`id`, `payment_id`, `purchase_id`, `amount_alloc`, `created_at`) VALUES
(1, 1, 13, 12000.00, '2025-12-24 20:12:01'),
(2, 2, 14, 9000.00, '2025-12-24 20:12:44'),
(3, 3, 15, 74000.00, '2025-12-24 20:32:26'),
(4, 4, 16, 18000.00, '2025-12-24 20:37:22'),
(5, 5, 18, 10500.00, '2025-12-24 23:06:27'),
(7, 7, 17, 12000.00, '2025-12-24 23:35:15'),
(9, 9, 20, 6025.00, '2025-12-24 23:39:10'),
(11, 11, 19, 1000.00, '2025-12-24 23:48:56'),
(12, 12, 21, 1000.00, '2025-12-25 01:03:28');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` int(11) NOT NULL,
  `unit_name` varchar(50) NOT NULL,
  `unit_code` varchar(20) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `units`
--

INSERT INTO `units` (`id`, `unit_name`, `unit_code`, `status`) VALUES
(1, 'Square Metersdf', 'SQM', 1),
(3, 'Piece', 'PCS', 1),
(4, 'Pallet', 'PALLET', 1),
(5, 'SQM', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `full_name` varchar(150) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `is_super_admin` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `full_name`, `email`, `phone`, `status`, `is_super_admin`, `created_at`, `updated_at`) VALUES
(1, 'superadmin', '$2b$10$VenANuZczyOBHdKvZz7Ge.75u4ahyCBWmRPaqeJu8MahyI04ghqTy', 'Primebuild Super Admin', NULL, NULL, 1, 1, '2025-12-24 11:14:58', '2025-12-24 15:23:51');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `trg_users_block_superadmin_delete` BEFORE DELETE ON `users` FOR EACH ROW BEGIN
  IF OLD.is_super_admin = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Super admin cannot be deleted';
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_users_block_superadmin_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
  IF OLD.is_super_admin = 1 THEN
    IF NEW.is_super_admin <> 1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Super admin flag cannot be removed';
    END IF;
    IF NEW.username <> OLD.username THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Super admin username cannot be changed';
    END IF;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `vat_settings`
--

CREATE TABLE `vat_settings` (
  `id` int(11) NOT NULL,
  `vat_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `default_vat_rate` decimal(5,2) NOT NULL DEFAULT 5.00,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vat_settings`
--

INSERT INTO `vat_settings` (`id`, `vat_enabled`, `default_vat_rate`, `created_at`, `updated_at`) VALUES
(1, 1, 5.00, '2025-12-24 11:14:58', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_account_code` (`code`),
  ADD KEY `idx_account_parent` (`parent_id`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_user` (`user_id`),
  ADD KEY `idx_audit_entity` (`entity`,`entity_id`);

--
-- Indexes for table `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_color_name` (`color_name`);

--
-- Indexes for table `company_profile`
--
ALTER TABLE `company_profile`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer_mobile` (`mobile`),
  ADD KEY `idx_customer_name` (`customer_name`);

--
-- Indexes for table `customer_payments`
--
ALTER TABLE `customer_payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cpay_no` (`payment_no`),
  ADD KEY `idx_cpay_date` (`payment_date`),
  ADD KEY `fk_cpay_customer` (`customer_id`),
  ADD KEY `fk_cpay_method` (`method_id`),
  ADD KEY `fk_cpay_user` (`created_by`);

--
-- Indexes for table `customer_payment_allocations`
--
ALTER TABLE `customer_payment_allocations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cpa_payment` (`payment_id`),
  ADD KEY `idx_cpa_invoice` (`tax_invoice_id`);

--
-- Indexes for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_delivery_no` (`delivery_no`),
  ADD KEY `idx_delivery_date` (`delivery_date`),
  ADD KEY `fk_del_invoice` (`tax_invoice_id`),
  ADD KEY `fk_del_customer` (`customer_id`),
  ADD KEY `fk_del_user` (`created_by`);

--
-- Indexes for table `delivery_items`
--
ALTER TABLE `delivery_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_di_delivery` (`delivery_id`),
  ADD KEY `idx_di_item` (`item_id`),
  ADD KEY `fk_di_sales_item` (`sales_doc_item_id`),
  ADD KEY `fk_di_unit` (`input_unit_id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_exp_no` (`expense_no`),
  ADD KEY `idx_exp_date` (`expense_date`),
  ADD KEY `fk_exp_cat` (`category_id`),
  ADD KEY `fk_exp_method` (`method_id`),
  ADD KEY `fk_exp_user` (`created_by`);

--
-- Indexes for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_exp_cat_name` (`category_name`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_item_variant` (`item_name`,`color_id`,`size_id`),
  ADD KEY `idx_item_name` (`item_name`),
  ADD KEY `fk_items_color` (`color_id`),
  ADD KEY `fk_items_size` (`size_id`),
  ADD KEY `fk_items_base_unit` (`base_unit_id`),
  ADD KEY `idx_items_unit_id` (`unit_id`);

--
-- Indexes for table `item_packaging`
--
ALTER TABLE `item_packaging`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `journal_entries`
--
ALTER TABLE `journal_entries`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_jv_no` (`entry_no`),
  ADD KEY `idx_jv_date` (`entry_date`),
  ADD KEY `idx_jv_ref` (`ref_type`,`ref_id`),
  ADD KEY `fk_jv_user` (`created_by`);

--
-- Indexes for table `journal_lines`
--
ALTER TABLE `journal_lines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_jl_entry` (`entry_id`),
  ADD KEY `idx_jl_account` (`account_id`),
  ADD KEY `idx_jl_customer` (`customer_id`),
  ADD KEY `idx_jl_supplier` (`supplier_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_method_name` (`method_name`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_permissions_code` (`code`),
  ADD KEY `idx_permissions_module_action` (`module`,`action`);

--
-- Indexes for table `petty_cash_entries`
--
ALTER TABLE `petty_cash_entries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_petty_date` (`entry_date`),
  ADD KEY `fk_petty_method` (`method_id`),
  ADD KEY `fk_petty_cat` (`category_id`),
  ADD KEY `fk_petty_user` (`created_by`),
  ADD KEY `idx_ref` (`ref_type`,`ref_id`),
  ADD KEY `idx_is_auto` (`is_auto`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_purchase_no` (`purchase_no`),
  ADD KEY `idx_purchase_date` (`purchase_date`),
  ADD KEY `fk_purchase_supplier` (`supplier_id`),
  ADD KEY `fk_purchase_user` (`created_by`),
  ADD KEY `idx_purchases_payment_method` (`payment_method_id`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pi_purchase` (`purchase_id`),
  ADD KEY `idx_pi_item` (`item_id`),
  ADD KEY `fk_pi_unit` (`input_unit_id`);

--
-- Indexes for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pr_no` (`return_no`),
  ADD KEY `idx_pr_date` (`return_date`),
  ADD KEY `fk_pr_supplier` (`supplier_id`),
  ADD KEY `fk_pr_purchase` (`purchase_id`),
  ADD KEY `fk_pr_user` (`created_by`),
  ADD KEY `idx_pr_refund_method` (`refund_method_id`);

--
-- Indexes for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pri_return` (`return_id`),
  ADD KEY `idx_pri_item` (`item_id`),
  ADD KEY `fk_pri_purchase_item` (`purchase_item_id`),
  ADD KEY `fk_pri_unit` (`input_unit_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_roles_name` (`role_name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `fk_rp_perm` (`permission_id`);

--
-- Indexes for table `sales_docs`
--
ALTER TABLE `sales_docs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_sales_doc_no` (`doc_no`),
  ADD KEY `idx_sales_doc_type_date` (`doc_type`,`doc_date`),
  ADD KEY `fk_sd_customer` (`customer_id`),
  ADD KEY `fk_sd_source` (`source_doc_id`),
  ADD KEY `fk_sd_user` (`created_by`);

--
-- Indexes for table `sales_doc_items`
--
ALTER TABLE `sales_doc_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sdi_doc` (`sales_doc_id`),
  ADD KEY `idx_sdi_item` (`item_id`),
  ADD KEY `fk_sdi_unit` (`input_unit_id`);

--
-- Indexes for table `sales_item_allocations`
--
ALTER TABLE `sales_item_allocations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sia_source` (`source_item_id`),
  ADD KEY `idx_sia_target` (`target_item_id`);

--
-- Indexes for table `sales_returns`
--
ALTER TABLE `sales_returns`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_sr_no` (`return_no`),
  ADD KEY `idx_sr_date` (`return_date`),
  ADD KEY `fk_sr_invoice` (`tax_invoice_id`),
  ADD KEY `fk_sr_customer` (`customer_id`),
  ADD KEY `fk_sr_user` (`created_by`);

--
-- Indexes for table `sales_return_items`
--
ALTER TABLE `sales_return_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sri_return` (`return_id`),
  ADD KEY `idx_sri_item` (`item_id`),
  ADD KEY `fk_sri_sales_item` (`sales_doc_item_id`),
  ADD KEY `fk_sri_unit` (`input_unit_id`);

--
-- Indexes for table `sequences`
--
ALTER TABLE `sequences`
  ADD PRIMARY KEY (`seq_key`);

--
-- Indexes for table `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_size_name` (`size_name`);

--
-- Indexes for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_adj_no` (`adjustment_no`),
  ADD KEY `idx_adj_date` (`adjustment_date`),
  ADD KEY `fk_adj_user` (`created_by`);

--
-- Indexes for table `stock_adjustment_items`
--
ALTER TABLE `stock_adjustment_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sai_adj` (`adjustment_id`),
  ADD KEY `idx_sai_item` (`item_id`);

--
-- Indexes for table `stock_ledger`
--
ALTER TABLE `stock_ledger`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_stock_item_date` (`item_id`,`tx_date`),
  ADD KEY `idx_stock_ref` (`ref_type`,`ref_id`);

--
-- Indexes for table `stock_reservations`
--
ALTER TABLE `stock_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_res_item` (`item_id`),
  ADD KEY `idx_res_proforma` (`proforma_id`),
  ADD KEY `fk_res_item_line` (`proforma_item_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_supplier_mobile` (`mobile`),
  ADD KEY `idx_supplier_name` (`supplier_name`);

--
-- Indexes for table `supplier_payments`
--
ALTER TABLE `supplier_payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_spay_no` (`payment_no`),
  ADD KEY `idx_spay_date` (`payment_date`),
  ADD KEY `fk_spay_supplier` (`supplier_id`),
  ADD KEY `fk_spay_method` (`method_id`),
  ADD KEY `fk_spay_user` (`created_by`),
  ADD KEY `idx_source_purchase_id` (`source_purchase_id`),
  ADD KEY `idx_is_auto` (`is_auto`);

--
-- Indexes for table `supplier_payment_allocations`
--
ALTER TABLE `supplier_payment_allocations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_spa_payment` (`payment_id`),
  ADD KEY `idx_spa_purchase` (`purchase_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_unit_code` (`unit_code`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_username` (`username`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `fk_ur_role` (`role_id`);

--
-- Indexes for table `vat_settings`
--
ALTER TABLE `vat_settings`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colors`
--
ALTER TABLE `colors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customer_payments`
--
ALTER TABLE `customer_payments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_payment_allocations`
--
ALTER TABLE `customer_payment_allocations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deliveries`
--
ALTER TABLE `deliveries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `delivery_items`
--
ALTER TABLE `delivery_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `journal_entries`
--
ALTER TABLE `journal_entries`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `journal_lines`
--
ALTER TABLE `journal_lines`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `petty_cash_entries`
--
ALTER TABLE `petty_cash_entries`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sales_docs`
--
ALTER TABLE `sales_docs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `sales_doc_items`
--
ALTER TABLE `sales_doc_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `sales_item_allocations`
--
ALTER TABLE `sales_item_allocations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales_returns`
--
ALTER TABLE `sales_returns`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sales_return_items`
--
ALTER TABLE `sales_return_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sizes`
--
ALTER TABLE `sizes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_adjustment_items`
--
ALTER TABLE `stock_adjustment_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stock_ledger`
--
ALTER TABLE `stock_ledger`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `stock_reservations`
--
ALTER TABLE `stock_reservations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier_payments`
--
ALTER TABLE `supplier_payments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `supplier_payment_allocations`
--
ALTER TABLE `supplier_payment_allocations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `fk_account_parent` FOREIGN KEY (`parent_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customer_payments`
--
ALTER TABLE `customer_payments`
  ADD CONSTRAINT `fk_cpay_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `fk_cpay_method` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `fk_cpay_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customer_payment_allocations`
--
ALTER TABLE `customer_payment_allocations`
  ADD CONSTRAINT `fk_cpa_invoice` FOREIGN KEY (`tax_invoice_id`) REFERENCES `sales_docs` (`id`),
  ADD CONSTRAINT `fk_cpa_payment` FOREIGN KEY (`payment_id`) REFERENCES `customer_payments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `deliveries`
--
ALTER TABLE `deliveries`
  ADD CONSTRAINT `fk_del_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `fk_del_invoice` FOREIGN KEY (`tax_invoice_id`) REFERENCES `sales_docs` (`id`),
  ADD CONSTRAINT `fk_del_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `delivery_items`
--
ALTER TABLE `delivery_items`
  ADD CONSTRAINT `fk_di_delivery` FOREIGN KEY (`delivery_id`) REFERENCES `deliveries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_di_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_di_sales_item` FOREIGN KEY (`sales_doc_item_id`) REFERENCES `sales_doc_items` (`id`),
  ADD CONSTRAINT `fk_di_unit` FOREIGN KEY (`input_unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `fk_exp_cat` FOREIGN KEY (`category_id`) REFERENCES `expense_categories` (`id`),
  ADD CONSTRAINT `fk_exp_method` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `fk_exp_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `fk_items_base_unit` FOREIGN KEY (`base_unit_id`) REFERENCES `units` (`id`),
  ADD CONSTRAINT `fk_items_color` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_items_size` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `item_packaging`
--
ALTER TABLE `item_packaging`
  ADD CONSTRAINT `fk_pack_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `journal_entries`
--
ALTER TABLE `journal_entries`
  ADD CONSTRAINT `fk_jv_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `journal_lines`
--
ALTER TABLE `journal_lines`
  ADD CONSTRAINT `fk_jl_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`),
  ADD CONSTRAINT `fk_jl_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_jl_entry` FOREIGN KEY (`entry_id`) REFERENCES `journal_entries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_jl_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `petty_cash_entries`
--
ALTER TABLE `petty_cash_entries`
  ADD CONSTRAINT `fk_petty_cat` FOREIGN KEY (`category_id`) REFERENCES `expense_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_petty_method` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `fk_petty_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `fk_purchase_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  ADD CONSTRAINT `fk_purchase_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_purchases_payment_method` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD CONSTRAINT `fk_pi_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_pi_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pi_unit` FOREIGN KEY (`input_unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `purchase_returns`
--
ALTER TABLE `purchase_returns`
  ADD CONSTRAINT `fk_pr_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pr_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  ADD CONSTRAINT `fk_pr_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `purchase_return_items`
--
ALTER TABLE `purchase_return_items`
  ADD CONSTRAINT `fk_pri_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_pri_purchase_item` FOREIGN KEY (`purchase_item_id`) REFERENCES `purchase_items` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pri_return` FOREIGN KEY (`return_id`) REFERENCES `purchase_returns` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pri_unit` FOREIGN KEY (`input_unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales_docs`
--
ALTER TABLE `sales_docs`
  ADD CONSTRAINT `fk_sd_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `fk_sd_source` FOREIGN KEY (`source_doc_id`) REFERENCES `sales_docs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sd_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `sales_doc_items`
--
ALTER TABLE `sales_doc_items`
  ADD CONSTRAINT `fk_sdi_doc` FOREIGN KEY (`sales_doc_id`) REFERENCES `sales_docs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sdi_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_sdi_unit` FOREIGN KEY (`input_unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `sales_item_allocations`
--
ALTER TABLE `sales_item_allocations`
  ADD CONSTRAINT `fk_sia_source` FOREIGN KEY (`source_item_id`) REFERENCES `sales_doc_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sia_target` FOREIGN KEY (`target_item_id`) REFERENCES `sales_doc_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales_returns`
--
ALTER TABLE `sales_returns`
  ADD CONSTRAINT `fk_sr_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `fk_sr_invoice` FOREIGN KEY (`tax_invoice_id`) REFERENCES `sales_docs` (`id`),
  ADD CONSTRAINT `fk_sr_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `sales_return_items`
--
ALTER TABLE `sales_return_items`
  ADD CONSTRAINT `fk_sri_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_sri_return` FOREIGN KEY (`return_id`) REFERENCES `sales_returns` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sri_sales_item` FOREIGN KEY (`sales_doc_item_id`) REFERENCES `sales_doc_items` (`id`),
  ADD CONSTRAINT `fk_sri_unit` FOREIGN KEY (`input_unit_id`) REFERENCES `units` (`id`);

--
-- Constraints for table `stock_adjustments`
--
ALTER TABLE `stock_adjustments`
  ADD CONSTRAINT `fk_adj_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `stock_adjustment_items`
--
ALTER TABLE `stock_adjustment_items`
  ADD CONSTRAINT `fk_sai_adj` FOREIGN KEY (`adjustment_id`) REFERENCES `stock_adjustments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sai_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `stock_ledger`
--
ALTER TABLE `stock_ledger`
  ADD CONSTRAINT `fk_stock_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);

--
-- Constraints for table `stock_reservations`
--
ALTER TABLE `stock_reservations`
  ADD CONSTRAINT `fk_res_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`),
  ADD CONSTRAINT `fk_res_item_line` FOREIGN KEY (`proforma_item_id`) REFERENCES `sales_doc_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_res_proforma` FOREIGN KEY (`proforma_id`) REFERENCES `sales_docs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `supplier_payments`
--
ALTER TABLE `supplier_payments`
  ADD CONSTRAINT `fk_spay_method` FOREIGN KEY (`method_id`) REFERENCES `payment_methods` (`id`),
  ADD CONSTRAINT `fk_spay_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  ADD CONSTRAINT `fk_spay_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `supplier_payment_allocations`
--
ALTER TABLE `supplier_payment_allocations`
  ADD CONSTRAINT `fk_spa_payment` FOREIGN KEY (`payment_id`) REFERENCES `supplier_payments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_spa_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
