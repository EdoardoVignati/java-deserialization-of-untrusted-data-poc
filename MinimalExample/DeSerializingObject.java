
import java.io.FileInputStream;

import java.io.IOException;

import java.io.ObjectInputStream;

public class DeSerializingObject {

public static void main(String[] args) {

Employee employeeInput = null;

FileInputStream fis = null;

ObjectInputStream ois = null;

try {

fis = new FileInputStream("/tmp/payload.ser");

ois = new ObjectInputStream(fis);

employeeInput = (Employee)ois.readObject();

System.out.println("Serialized data is restored from Employee.ser file");

ois.close();

fis.close();

} catch (IOException | ClassNotFoundException e) {

e.printStackTrace();

} 

System.out.println("Name of employee is : " + employeeInput.getSerializeValueName());

System.out.println("Salary of employee is : " + employeeInput.getNonSerializeValueSalary());

}

}
