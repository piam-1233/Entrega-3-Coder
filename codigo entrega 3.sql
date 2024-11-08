
Drop schema VRM;

CREATE SCHEMA IF NOT EXISTS VRM;

USE VRM;

CREATE TABLE IF NOT EXISTS Branch (
  BranchID INT NOT NULL,
  BranchName VARCHAR(100) NOT NULL,
  Location VARCHAR(100) NOT NULL,
  PRIMARY KEY (BranchID),
  UNIQUE INDEX BranchID_UNIQUE (BranchID ASC)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Vehicle (
  VIN VARCHAR(17) NOT NULL,
  Make VARCHAR(50) NOT NULL,
  Model VARCHAR(50) NOT NULL,
  Year INT NOT NULL,
  Mileage INT NOT NULL,
  PurchasePrice DATE NOT NULL,
  Status VARCHAR(20) NOT NULL,
  Branch_BranchID INT NOT NULL,
  PRIMARY KEY (VIN, Branch_BranchID),
  INDEX fk_Vehicle_Branch_idx (Branch_BranchID ASC),
  CONSTRAINT fk_Vehicle_Branch
    FOREIGN KEY (Branch_BranchID)
    REFERENCES Branch (BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Employee (
  EmployeeID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Role VARCHAR(50) NOT NULL,
  HireDate DATE NOT NULL,
  Branch_BranchID INT NOT NULL,
  PRIMARY KEY (EmployeeID, Branch_BranchID),
  UNIQUE INDEX EmployeeID_UNIQUE (EmployeeID ASC),
  INDEX fk_Employee_Branch1_idx (Branch_BranchID ASC),
  CONSTRAINT fk_Employee_Branch1
    FOREIGN KEY (Branch_BranchID)
    REFERENCES Branch (BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RepairJob (
  RepairJobID INT NOT NULL,
  ServiceType VARCHAR(50) NOT NULL,
  PartsCost DECIMAL(10,2) NOT NULL,
  LaborHours DECIMAL(5,2) NOT NULL,
  TotalCost DECIMAL(10,2) NOT NULL,
  Status VARCHAR(20) NOT NULL,
  Date DATE NOT NULL,
  Vehicle_VIN VARCHAR(17) NOT NULL,
  Vehicle_Branch_BranchID INT NOT NULL,
  Employee_EmployeeID INT NOT NULL,
  PRIMARY KEY (RepairJobID, Vehicle_VIN, Vehicle_Branch_BranchID, Employee_EmployeeID),
  UNIQUE INDEX RepairJobID_UNIQUE (RepairJobID ASC),
  INDEX fk_RepairJob_Vehicle1_idx (Vehicle_VIN ASC, Vehicle_Branch_BranchID ASC),
  INDEX fk_RepairJob_Employee1_idx (Employee_EmployeeID ASC),
  CONSTRAINT fk_RepairJob_Vehicle1
    FOREIGN KEY (Vehicle_VIN, Vehicle_Branch_BranchID)
    REFERENCES Vehicle (VIN, Branch_BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_RepairJob_Employee1
    FOREIGN KEY (Employee_EmployeeID)
    REFERENCES Employee (EmployeeID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Supplier (
  SupplierID INT NOT NULL,
  SupplierName VARCHAR(100) NOT NULL,
  ContactInfo VARCHAR(100) NOT NULL,
  DeliveryRating DECIMAL(3,2) NOT NULL,
  QualityRating DECIMAL(3,2) NOT NULL,
  PriceRating DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (SupplierID),
  UNIQUE INDEX SupplierID_UNIQUE (SupplierID ASC)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Part (
  PartID INT NOT NULL,
  PartName VARCHAR(50) NOT NULL,
  PartType VARCHAR(50) NOT NULL,
  UnitCost DECIMAL(10,2) NOT NULL,
  StockQuantity INT NOT NULL,
  Supplier_SupplierID INT NOT NULL,
  Vehicle_VIN VARCHAR(17) NOT NULL,
  Vehicle_Branch_BranchID INT NOT NULL,
  PRIMARY KEY (PartID, Supplier_SupplierID, Vehicle_VIN, Vehicle_Branch_BranchID),
  UNIQUE INDEX PartID_UNIQUE (PartID ASC),
  INDEX fk_Part_Supplier1_idx (Supplier_SupplierID ASC),
  INDEX fk_Part_Vehicle1_idx (Vehicle_VIN ASC, Vehicle_Branch_BranchID ASC),
  CONSTRAINT fk_Part_Supplier1
    FOREIGN KEY (Supplier_SupplierID)
    REFERENCES Supplier (SupplierID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Part_Vehicle1
    FOREIGN KEY (Vehicle_VIN, Vehicle_Branch_BranchID)
    REFERENCES Vehicle (VIN, Branch_BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Client (
  ClientID INT NOT NULL,
  Name VARCHAR(100) NOT NULL,
  ContactInfo VARCHAR(100) NOT NULL,
  Address VARCHAR(200) NOT NULL,
  ClientType VARCHAR(20) NOT NULL,
  PRIMARY KEY (ClientID),
  UNIQUE INDEX ClientID_UNIQUE (ClientID ASC)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Promotion (
  PromotionID INT NOT NULL,
  Description VARCHAR(255) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  DiscountRate DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (PromotionID),
  UNIQUE INDEX PromotionID_UNIQUE (PromotionID ASC)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Sale (
  SaleID INT NOT NULL,
  SaleDate DATE NOT NULL,
  SalePrice DECIMAL(10,2) NOT NULL,
  Vehicle_VIN VARCHAR(17) NOT NULL,
  Vehicle_Branch_BranchID INT NOT NULL,
  Client_ClientID INT NOT NULL,
  Employee_EmployeeID INT NOT NULL,
  Promotion_PromotionID INT NOT NULL,
  PRIMARY KEY (SaleID, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Promotion_PromotionID),
  UNIQUE INDEX SaleID_UNIQUE (SaleID ASC),
  INDEX fk_Sale_Vehicle1_idx (Vehicle_VIN ASC, Vehicle_Branch_BranchID ASC),
  INDEX fk_Sale_Client1_idx (Client_ClientID ASC),
  INDEX fk_Sale_Employee1_idx (Employee_EmployeeID ASC),
  INDEX fk_Sale_Promotion1_idx (Promotion_PromotionID ASC),
  CONSTRAINT fk_Sale_Vehicle1
    FOREIGN KEY (Vehicle_VIN, Vehicle_Branch_BranchID)
    REFERENCES Vehicle (VIN, Branch_BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Sale_Client1
    FOREIGN KEY (Client_ClientID)
    REFERENCES Client (ClientID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Sale_Employee1
    FOREIGN KEY (Employee_EmployeeID)
    REFERENCES Employee (EmployeeID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Sale_Promotion1
    FOREIGN KEY (Promotion_PromotionID)
    REFERENCES Promotion (PromotionID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ServiceAppointment (
  AppointmentID INT NOT NULL,
  AppointmentDate DATE NOT NULL,
  ServiceType VARCHAR(50) NOT NULL,
  Status VARCHAR(20) NOT NULL,
  Vehicle_VIN VARCHAR(17) NOT NULL,
  Vehicle_Branch_BranchID INT NOT NULL,
  Client_ClientID INT NOT NULL,
  Employee_EmployeeID INT NOT NULL,
  Employee_Branch_BranchID INT NOT NULL,
  PRIMARY KEY (AppointmentID, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Employee_Branch_BranchID),
  UNIQUE INDEX AppointmentID_UNIQUE (AppointmentID ASC),
  INDEX fk_ServiceAppointment_Vehicle1_idx (Vehicle_VIN ASC, Vehicle_Branch_BranchID ASC),
  INDEX fk_ServiceAppointment_Client1_idx (Client_ClientID ASC),
  INDEX fk_ServiceAppointment_Employee1_idx (Employee_EmployeeID ASC, Employee_Branch_BranchID ASC),
  CONSTRAINT fk_ServiceAppointment_Vehicle1
    FOREIGN KEY (Vehicle_VIN, Vehicle_Branch_BranchID)
    REFERENCES Vehicle (VIN, Branch_BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ServiceAppointment_Client1
    FOREIGN KEY (Client_ClientID)
    REFERENCES Client (ClientID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ServiceAppointment_Employee1
    FOREIGN KEY (Employee_EmployeeID, Employee_Branch_BranchID)
    REFERENCES Employee (EmployeeID, Branch_BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Warranty (
  WarrantyID INT NOT NULL,
  CoverageDetails TEXT NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  Provider VARCHAR(100) NOT NULL,
  PRIMARY KEY (WarrantyID),
  UNIQUE INDEX WarrantyID_UNIQUE (WarrantyID ASC)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS CustomerFeedback (
  FeedbackID INT NOT NULL,
  FeedbackDate DATE NOT NULL,
  Rating INT NOT NULL,
  Comments TEXT NOT NULL,
  Sale_SaleID INT NOT NULL,
  Sale_Vehicle_VIN VARCHAR(17) NOT NULL,
  Sale_Vehicle_Branch_BranchID INT NOT NULL,
  Sale_Client_ClientID INT NOT NULL,
  Sale_Employee_EmployeeID INT NOT NULL,
  Sale_Promotion_PromotionID INT NOT NULL,
  Client_ClientID INT NOT NULL,
  PRIMARY KEY (FeedbackID, Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID, Client_ClientID),
  UNIQUE INDEX FeedbackID_UNIQUE (FeedbackID ASC),
  INDEX fk_CustomerFeedback_Sale1_idx (Sale_SaleID ASC, Sale_Vehicle_VIN ASC, Sale_Vehicle_Branch_BranchID ASC, Sale_Client_ClientID ASC, Sale_Employee_EmployeeID ASC, Sale_Promotion_PromotionID ASC),
  INDEX fk_CustomerFeedback_Client1_idx (Client_ClientID ASC),
  CONSTRAINT fk_CustomerFeedback_Sale1
    FOREIGN KEY (Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID)
    REFERENCES Sale (SaleID, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Promotion_PromotionID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_CustomerFeedback_Client1
    FOREIGN KEY (Client_ClientID)
    REFERENCES Client (ClientID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS FinancialReport (
  ReportID INT NOT NULL,
  ReportDate DATE NOT NULL,
  TotalSales DECIMAL(15,2) NOT NULL,
  TotalExpenses DECIMAL(15,2) NOT NULL,
  NetProfit DECIMAL(15,2) NOT NULL,
  Branch_BranchID INT NOT NULL,
  PRIMARY KEY (ReportID, Branch_BranchID),
  UNIQUE INDEX ReportID_UNIQUE (ReportID ASC),
  INDEX fk_FinancialReport_Branch1_idx (Branch_BranchID ASC),
  CONSTRAINT fk_FinancialReport_Branch1
    FOREIGN KEY (Branch_BranchID)
    REFERENCES Branch (BranchID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Insurance (
  InsuranceID INT NOT NULL,
  PolicyNumber VARCHAR(50) NOT NULL,
  InsuranceProvider VARCHAR(100) NOT NULL,
  CoverageType VARCHAR(50) NOT NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL,
  Client_ClientID INT NOT NULL,
  PRIMARY KEY (InsuranceID, Client_ClientID),
  UNIQUE INDEX InsuranceID_UNIQUE (InsuranceID ASC),
  INDEX fk_Insurance_Client1_idx (Client_ClientID ASC),
  CONSTRAINT fk_Insurance_Client1
    FOREIGN KEY (Client_ClientID)
    REFERENCES Client (ClientID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS SupplierRating (
  RatingID INT NOT NULL,
  RatingDate DATE NOT NULL,
  QualityScore DECIMAL(3,2) NOT NULL,
  DeliveryScore DECIMAL(3,2) NOT NULL,
  PriceScore DECIMAL(3,2) NOT NULL,
  OverallScore DECIMAL(3,2) NOT NULL,
  Supplier_SupplierID INT NOT NULL,
  PRIMARY KEY (RatingID, Supplier_SupplierID),
  UNIQUE INDEX RatingID_UNIQUE (RatingID ASC),
  INDEX fk_SupplierRating_Supplier1_idx (Supplier_SupplierID ASC),
  CONSTRAINT fk_SupplierRating_Supplier1
    FOREIGN KEY (Supplier_SupplierID)
    REFERENCES Supplier (SupplierID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS SaleWarranty (
  Sale_SaleID INT NOT NULL,
  Sale_Vehicle_VIN VARCHAR(17) NOT NULL,
  Sale_Vehicle_Branch_BranchID INT NOT NULL,
  Sale_Client_ClientID INT NOT NULL,
  Sale_Employee_EmployeeID INT NOT NULL,
  Sale_Promotion_PromotionID INT NOT NULL,
  Warranty_WarrantyID INT NOT NULL,
  PRIMARY KEY (Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID, Warranty_WarrantyID),
  INDEX fk_SaleWarranty_Warranty1_idx (Warranty_WarrantyID ASC),
  CONSTRAINT fk_SaleWarranty_Sale1
    FOREIGN KEY (Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID)
    REFERENCES Sale (SaleID, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Promotion_PromotionID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_SaleWarranty_Warranty1
    FOREIGN KEY (Warranty_WarrantyID)	
    REFERENCES Warranty (WarrantyID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) 
ENGINE=InnoDB; 


VIEWS: 
1)View: AvailableVehicles
This view will show vehicles that are available for rent.
CREATE VIEW AvailableVehicles AS
SELECT 
    v.VIN, 
    v.Make, 
    v.Model, 
    v.Year, 
    v.Mileage, 
    v.Status, 
    b.BranchName, 
    b.Location
FROM Vehicle v
JOIN Branch b ON v.Branch_BranchID = b.BranchID
WHERE v.Status = 'Available';

2 View: BranchSalesSummary
This view will summarize the sales per branch.

CREATE VIEW BranchSalesSummary AS
SELECT 
    b.BranchID, 
    b.BranchName, 
    COUNT(s.SaleID) AS TotalSales, 
    SUM(s.SalePrice) AS TotalRevenue
FROM Sale s
JOIN Vehicle v ON s.Vehicle_VIN = v.VIN
JOIN Branch b ON v.Branch_BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName; 


3 View: ClientServiceHistory
This view shows the service history for clients based on their vehicles.

CREATE VIEW ClientServiceHistory AS
SELECT 
    c.ClientID, 
    c.Name AS ClientName, 
    v.VIN, 
    v.Make, 
    v.Model, 
    r.RepairJobID, 
    r.ServiceType, 
    r.Date AS RepairDate, 
    r.TotalCost
FROM Client c
JOIN Sale s ON c.ClientID = s.Client_ClientID
JOIN Vehicle v ON s.Vehicle_VIN = v.VIN
JOIN RepairJob r ON r.Vehicle_VIN = v.VIN
ORDER BY c.ClientID, r.Date; 
FUNCTIONS: 

1. CalculateTotalRepairCost Function (MySQL)
DELIMITER $$

CREATE FUNCTION CalculateTotalRepairCost(vehicleVIN VARCHAR(17))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_cost DECIMAL(10,2);

    -- Calculate the total repair cost for the given vehicle
    SELECT COALESCE(SUM(TotalCost), 0)
    INTO total_cost
    FROM RepairJob
    WHERE Vehicle_VIN = vehicleVIN;

    RETURN total_cost;
END$$

DELIMITER ;



2. GetVehicleAge Function (MySQL)
DELIMITER $$

CREATE FUNCTION GetVehicleAge(vehicleVIN VARCHAR(17))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE vehicle_year INT;

    -- Fetch the vehicle year from the database
    SELECT Year 
    INTO vehicle_year
    FROM Vehicle
    WHERE VIN = vehicleVIN;

    -- Return the vehicle age
    RETURN YEAR(CURDATE()) - vehicle_year;
END$$

DELIMITER ;

STORED PROCEDURES:

1. UpdateVehicleMileage Stored Procedure 
DELIMITER $$

CREATE PROCEDURE UpdateVehicleMileage(IN vehicleVIN VARCHAR(17), IN newMileage INT)
BEGIN
    -- Update the vehicle mileage for the given VIN
    UPDATE Vehicle
    SET Mileage = newMileage
    WHERE VIN = vehicleVIN;
END$$

DELIMITER ; 

2. RecordRepairJob Stored Procedure
DELIMITER $$

CREATE PROCEDURE RecordRepairJob(
    IN repairJobID INT,
    IN serviceType VARCHAR(50),
    IN partsCost DECIMAL(10,2),
    IN laborHours DECIMAL(5,2),
    IN totalCost DECIMAL(10,2),
    IN status VARCHAR(20),
    IN repairDate DATE,
    IN vehicleVIN VARCHAR(17),
    IN vehicleBranchID INT,
    IN employeeID INT
)
BEGIN
    -- Insert a new repair job into the RepairJob table
    INSERT INTO RepairJob (
        RepairJobID, ServiceType, PartsCost, LaborHours, TotalCost, Status, Date, Vehicle_VIN, Vehicle_Branch_BranchID, Employee_EmployeeID
    ) VALUES (
        repairJobID, serviceType, partsCost, laborHours, totalCost, status, repairDate, vehicleVIN, vehicleBranchID, employeeID
    );
END$$

DELIMITER ;



3. AssignVehicleToBranch Stored Procedure
DELIMITER $$

CREATE PROCEDURE AssignVehicleToBranch(
    IN vehicleVIN VARCHAR(17),
    IN newBranchID INT
)
BEGIN
    -- Update the vehicle's branch assignment
    UPDATE Vehicle
    SET Branch_BranchID = newBranchID
    WHERE VIN = vehicleVIN;
END$$

DELIMITER ; 





4. RecordSale Stored Procedure
DELIMITER $$

CREATE PROCEDURE RecordSale(
    IN saleID INT,
    IN saleDate DATE,
    IN salePrice DECIMAL(10,2),
    IN vehicleVIN VARCHAR(17),
    IN vehicleBranchID INT,
    IN clientID INT,
    IN employeeID INT,
    IN promotionID INT
)
BEGIN
    -- Insert a new sale into the Sale table
    INSERT INTO Sale (
        SaleID, SaleDate, SalePrice, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Promotion_PromotionID
    ) VALUES (
        saleID, saleDate, salePrice, vehicleVIN, vehicleBranchID, clientID, employeeID, promotionID
    );
END$$

DELIMITER ; 



TRIGGERS:

1: Trigger for Updating Vehicle Table After Mileage Update

DELIMITER $$

CREATE TRIGGER AfterMileageUpdate
AFTER UPDATE ON Vehicle
FOR EACH ROW
BEGIN
    -- Check if mileage has changed
    IF NEW.Mileage != OLD.Mileage THEN
        -- Log the mileage change in a separate table, for example, MileageHistory
        INSERT INTO MileageHistory (VIN, OldMileage, NewMileage, ChangeDate)
        VALUES (NEW.VIN, OLD.Mileage, NEW.Mileage, NOW());
    END IF;
END$$

DELIMITER ; 



2: Trigger to Update TotalCost in Repair Jobs:
DELIMITER $$

CREATE TRIGGER BeforeRepairJobInsert
BEFORE INSERT ON RepairJob
FOR EACH ROW
BEGIN
    -- Calculate the total cost as parts cost + labor cost (assuming labor is $50/hour)
    SET NEW.TotalCost = NEW.PartsCost + (NEW.LaborHours * 50);
END$$

DELIMITER ;



3: Trigger for Automatic Promotion on Sale:
DELIMITER $$

CREATE TRIGGER BeforeSaleInsert
BEFORE INSERT ON Sale
FOR EACH ROW
BEGIN
    -- Automatically apply a promotion if the sale price exceeds a threshold (e.g., $50,000)
    IF NEW.SalePrice > 50000 THEN
        SET NEW.Promotion_PromotionID = (SELECT PromotionID FROM Promotion WHERE PromotionType = 'HighValueSale');
    END IF;
END$$

DELIMITER ;





INSERT INTO Branch (BranchID, BranchName, Location)
VALUES 
(1, 'Main Branch', 'Downtown'),
(2, 'East Branch', 'Eastside');
INSERT INTO Employee (EmployeeID, Name, Role, HireDate, Branch_BranchID)
VALUES 
(1, 'Alice Johnson', 'Manager', '2020-03-15', 1),
(2, 'Bob Smith', 'Technician', '2021-06-01', 2);
INSERT INTO Supplier (SupplierID, SupplierName, ContactInfo, DeliveryRating, QualityRating, PriceRating)
VALUES 
(1, 'AutoParts Co.', '123-456-7890', 4.5, 4.8, 4.3),
(2, 'Brake Suppliers Ltd.', '987-654-3210', 4.0, 4.2, 4.1);
INSERT INTO Vehicle (VIN, Make, Model, Year, Mileage, PurchasePrice, Status, Branch_BranchID)
VALUES 
('1HGCM82633A123456', 'Honda', 'Accord', 2022, 10000, '2022-07-10', 'Available', 1),
('2C3KA53G25H123456', 'Chrysler', '300C', 2020, 25000, '2021-08-15', 'In Service', 2);
INSERT INTO Part (PartID, PartName, PartType, UnitCost, StockQuantity, Supplier_SupplierID, Vehicle_VIN, Vehicle_Branch_BranchID)
VALUES 
(1, 'Brake Pads', 'Brake System', 150.00, 50, 1, '1HGCM82633A123456', 1),
(2, 'Oil Filter', 'Engine', 25.00, 100, 2, '2C3KA53G25H123456', 2);
INSERT INTO Client (ClientID, Name, ContactInfo, Address, ClientType)
VALUES 
(1, 'John Doe', 'john@example.com', '123 Main St', 'Individual'),
(2, 'Jane Smith', 'jane@example.com', '456 Elm St', 'Business');
INSERT INTO RepairJob (RepairJobID, ServiceType, PartsCost, LaborHours, TotalCost, Status, Date, Vehicle_VIN, Vehicle_Branch_BranchID, Employee_EmployeeID)
VALUES 
(1, 'Brake Repair', 150.00, 2.0, 300.00, 'Completed', '2023-01-15', '1HGCM82633A123456', 1, 2),
(2, 'Oil Change', 25.00, 1.0, 75.00, 'Pending', '2023-02-10', '2C3KA53G25H123456', 2, 1);
INSERT INTO Promotion (PromotionID, Description, StartDate, EndDate, DiscountRate)
VALUES 
(1, 'Winter Sale', '2023-12-01', '2023-12-31', 10.00),
(2, 'Summer Discount', '2023-06-01', '2023-06-30', 15.00);
INSERT INTO Sale (SaleID, SaleDate, SalePrice, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Promotion_PromotionID)
VALUES 
(1, '2023-01-20', 25000.00, '1HGCM82633A123456', 1, 1, 1, 1),
(2, '2023-03-15', 18000.00, '2C3KA53G25H123456', 2, 2, 2, 2);
INSERT INTO ServiceAppointment (AppointmentID, AppointmentDate, ServiceType, Status, Vehicle_VIN, Vehicle_Branch_BranchID, Client_ClientID, Employee_EmployeeID, Employee_Branch_BranchID)
VALUES 
(1, '2023-04-01', 'Oil Change', 'Scheduled', '1HGCM82633A123456', 1, 1, 2, 1),
(2, '2023-05-15', 'Brake Replacement', 'Completed', '2C3KA53G25H123456', 2, 2, 1, 2);
INSERT INTO Warranty (WarrantyID, CoverageDetails, StartDate, EndDate, Provider)
VALUES 
(1, 'Full Coverage for 2 Years', '2023-01-01', '2025-01-01', 'WarrantyCorp'),
(2, 'Engine Coverage for 1 Year', '2023-05-01', '2024-05-01', 'EngineProtect Inc.');
INSERT INTO CustomerFeedback (FeedbackID, FeedbackDate, Rating, Comments, Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID, Client_ClientID)
VALUES 
(1, '2023-02-01', 5, 'Great service and smooth transaction!', 1, '1HGCM82633A123456', 1, 1, 1, 1, 1),
(2, '2023-04-01', 4, 'Good experience, but a bit slow.', 2, '2C3KA53G25H123456', 2, 2, 2, 2, 2);
INSERT INTO FinancialReport (ReportID, ReportDate, TotalSales, TotalExpenses, NetProfit, Branch_BranchID)
VALUES 
(1, '2023-12-31', 500000.00, 300000.00, 200000.00, 1),
(2, '2023-12-31', 350000.00, 200000.00, 150000.00, 2);
INSERT INTO Insurance (InsuranceID, PolicyNumber, InsuranceProvider, CoverageType, StartDate, EndDate, Client_ClientID)
VALUES 
(1, 'POL123456', 'AutoInsure Co.', 'Full Coverage', '2023-01-01', '2024-01-01', 1),
(2, 'POL654321', 'SafeDrive Inc.', 'Liability', '2023-06-01', '2024-06-01', 2);
INSERT INTO SupplierRating (RatingID, RatingDate, QualityScore, DeliveryScore, PriceScore, OverallScore, Supplier_SupplierID)
VALUES 
(1, '2023-01-15', 4.5, 4.6, 4.3, 4.5, 1),
(2, '2023-02-20', 4.2, 4.0, 4.1, 4.1, 2);
INSERT INTO Sale_Warranty (Sale_SaleID, Sale_Vehicle_VIN, Sale_Vehicle_Branch_BranchID, Sale_Client_ClientID, Sale_Employee_EmployeeID, Sale_Promotion_PromotionID, Warranty_WarrantyID)
VALUES 
(1, '1HGCM82633A123456', 1, 1, 1, 1, 1),
(2, '2C3KA53G25H123456', 2, 2, 2, 2, 2); 
