package com.HIS.view;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Color;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.JTextField;
import javax.swing.SpinnerDateModel;
import javax.swing.border.TitledBorder;

import com.HIS.Controller.DoctorTableModel;
import com.HIS.model.Doctor;
import com.toedter.calendar.JDateChooser;

public class DoctorProfilePanel extends JPanel {
    protected JTextField nameField,lnameField, contactField, emailField, addressField,adressField2,addressField3,pinField, ageField;
    protected JComboBox<String> qualificationDropDown;
    protected JComboBox<String> departmentDropdown, specializationDropdown;
    protected JSpinner startTimeSpinner, endTimeSpinner, availableFromDaySpinner, availableToDaySpinner;
    protected JDateChooser dobPicker;
    protected JCheckBox[] dayCheckBoxes;
    protected JTextField consultationFeeField;
    protected JButton saveButton;
 
    protected final Map<String,List<String>>departmentSpecialisationMap=new HashMap<>();

    public DoctorProfilePanel(CardLayout cardLayout, JPanel container, DoctorTableModel tableModel) {
        setLayout(new BorderLayout(10, 10));
        setBackground(Color.WHITE);
        //updating...
        JLabel header = new JLabel("Doctor Registration", JLabel.CENTER);
        header.setOpaque(true);
        header.setBackground(Color.BLUE);
        header.setForeground(Color.WHITE);
        header.setFont(new Font("Arial", Font.BOLD, 20));
        add(header, BorderLayout.NORTH);
        
        initializeDepartmentSpecializationMap(); 
        
         
        JPanel mainFormPanel = new JPanel(new GridBagLayout());
        mainFormPanel.setBackground(Color.WHITE);
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(2, 2,2,2);
        gbc.anchor = GridBagConstraints.CENTER;
        gbc.fill = GridBagConstraints.HORIZONTAL;
      //personal details panel
        JPanel personalDetailsPanel=createSectionPanel("Personal Details");
        personalDetailsPanel.setBackground(Color.WHITE);
        nameField = new JTextField(7);
        lnameField=new JTextField(7);
        dobPicker = new JDateChooser();
        ageField = new JTextField(7);
        ageField.setEditable(false);  
        dobPicker.getDateEditor().addPropertyChangeListener("date", evt ->{
        	Date selectedDate= dobPicker.getDate();
        	if(selectedDate!=null) {
        		LocalDate dob=selectedDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
        		int age=calculateAge(dob);
        		ageField.setText(String.valueOf(age));
        		}
        	else {
        		ageField.setText("");
        	}
        });
        addSectionField(personalDetailsPanel,"First Name :",nameField,"Last Name",lnameField,gbc,0);
        addSectionField(personalDetailsPanel, "Date of Birth:", dobPicker, "Age:", ageField, gbc, 1);
 
        // contact details
       
        JPanel contactDetailsPanel = createSectionPanel("Contact Details");
        contactDetailsPanel.setBackground(Color.WHITE);
        contactField = new JTextField(7);
        emailField = new JTextField(7);
        addressField = new JTextField(7);
        adressField2 = new JTextField(7);
        addressField3 = new JTextField(7);
        pinField = new JTextField(7);

        addSectionField(contactDetailsPanel, "Contact:", contactField, "Email:", emailField, gbc, 0);
        addSectionField(contactDetailsPanel, "Address Line 1:", addressField, "Address Line 2:", adressField2, gbc, 1);
        addSectionField(contactDetailsPanel, "Address Line 3:", addressField3, "Pincode:", pinField, gbc, 2);
        
       
     // ADDITIONAL DETAILS PANEL
        JPanel additionalDetailsPanel = createSectionPanel("Additional Details");
        additionalDetailsPanel.setBackground(Color.WHITE);
        qualificationDropDown=new JComboBox<>(new String[] {
        		"MBBS,MD","MBBS,MS","MBBS,DNB","MBBS,MCh","MD,DM","MBBS,FRCS","MBBS,MD,FRCP","MBBS,DO"
        });

        departmentDropdown = new JComboBox<>(departmentSpecialisationMap.keySet().toArray(new String[0]));
        specializationDropdown = new JComboBox<>();
        
        updateSpecializations();
        
        departmentDropdown.addActionListener(e->updateSpecializations());
        
        startTimeSpinner = new JSpinner(new SpinnerDateModel());
        endTimeSpinner = new JSpinner(new SpinnerDateModel());
		
        // Format spinners
        startTimeSpinner.setEditor(new JSpinner.DateEditor(startTimeSpinner, "HH:mm"));
        endTimeSpinner.setEditor(new JSpinner.DateEditor(endTimeSpinner, "HH:mm"));

        
        String[] days= {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        dayCheckBoxes=new JCheckBox[days.length];
        JPanel daysPanel=new JPanel(new FlowLayout(FlowLayout.LEFT,2,2));
        for(int i=0;i<days.length;i++) {
        	dayCheckBoxes[i]=new JCheckBox(days[i]);
        	daysPanel.add(dayCheckBoxes[i]);
        
        }
      //consultation fee
        consultationFeeField=new JTextField(7);
        // Add fields to the form
        
        
        addSectionField(additionalDetailsPanel, "Qualification:", qualificationDropDown, "Department:", departmentDropdown, gbc, 0);
        addSectionField(additionalDetailsPanel, "Specialization:", specializationDropdown, "Start Time:", startTimeSpinner, gbc, 1);
        addSectionField(additionalDetailsPanel, "End Time:", endTimeSpinner, "Consultation Fee:", consultationFeeField, gbc, 2);
        addSectionField(additionalDetailsPanel, "Available Days:", daysPanel, null, null, gbc, 3);

       
        // Buttons for Save and Clear
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
        buttonPanel.setBackground(Color.WHITE);
        saveButton = new JButton("Save");
        saveButton.addActionListener(e -> saveDoctorProfile(tableModel));
        JButton clearButton = new JButton("Clear");
        clearButton.addActionListener(e -> clearFields());
        buttonPanel.add(saveButton);
        buttonPanel.add(clearButton);
        
        
        mainFormPanel.setAlignmentX(JPanel.LEFT_ALIGNMENT);
     // Add Sections to Main Form Panel
        gbc.gridy = 0;
        mainFormPanel.add(personalDetailsPanel, gbc);
        gbc.gridy++;
        mainFormPanel.add(contactDetailsPanel, gbc);
        gbc.gridy++;
        mainFormPanel.add(additionalDetailsPanel, gbc);
        gbc.gridy++;
        mainFormPanel.add(buttonPanel, gbc);

        add(mainFormPanel, BorderLayout.CENTER);

        JButton goToBrowserButton = new JButton("Go to Browser Page");
        goToBrowserButton.addActionListener(e -> cardLayout.show(container, "Browser"));
        add(goToBrowserButton, BorderLayout.SOUTH);
    }
    public void initializeDepartmentSpecializationMap() {
    	departmentSpecialisationMap.put("Cardiology",Arrays.asList("Pediatric Cardiology","Electrophysiology"));
    	departmentSpecialisationMap.put("Dermatology",Arrays.asList("Cosmetic Dermatology","Pediatric Dermatology"));
    	departmentSpecialisationMap.put("Neurology",Arrays.asList("Neuroimunology","Epileptologist","Pediatric Neurology"));
    	departmentSpecialisationMap.put("Pediatrics",Arrays.asList("Pediatric Cardiology","Pediatric Neurology","Pediatric Opthamology"));
    	departmentSpecialisationMap.put("Opthamology",Arrays.asList("Pediatric Opthamologist","Retina specialist"));
    }
    private void updateSpecializations() {
    	String selectedDepartment=(String)departmentDropdown.getSelectedItem();
    	List <String> specializations=departmentSpecialisationMap.getOrDefault(selectedDepartment, Collections.emptyList());
    	specializationDropdown.removeAllItems();
    	for(String specialization:specializations) {
    		specializationDropdown.addItem(specialization);
    	}
    	
    }
    private JPanel createSectionPanel(String title) {
        JPanel sectionPanel = new JPanel(new GridBagLayout());
        sectionPanel.setBackground(Color.WHITE);
        sectionPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.GRAY), title,
                TitledBorder.DEFAULT_JUSTIFICATION, TitledBorder.TOP, new Font("Arial", Font.BOLD, 14)));
        if(title.equals("Additional Details")) {
        	sectionPanel.setPreferredSize(new java.awt.Dimension(700,200));
        }
        else {
        	sectionPanel.setPreferredSize(new java.awt.Dimension(600,200));
        }
        return sectionPanel;
    }
    
    private void addSectionField(JPanel panel, String label1, JComponent field1, String label2, JComponent field2, GridBagConstraints gbc, int row) {
        // Minimal insets to remove padding
        gbc.insets = new Insets(1, 1, 1, 1); 
        gbc.ipadx = 0; // No internal padding
        gbc.ipady = 0;

        // Ensure uniform alignment for both labels and fields
        gbc.anchor = GridBagConstraints.EAST;

        // Label 1
        gbc.gridx = 0;
        gbc.gridy = row;
        gbc.weightx = 0.0; // No additional space for label
        panel.add(new JLabel(label1), gbc);

        // Field 1
        gbc.gridx = 1;
        gbc.weightx = 1.0; // Field takes horizontal space
        gbc.fill = GridBagConstraints.HORIZONTAL;
        field1.setPreferredSize(new java.awt.Dimension(120, 30)); // Set fixed field size
        panel.add(field1, gbc);

        if (label2 != null && field2 != null) {
            // Label 2
            gbc.gridx = 2;
            gbc.weightx = 0.0; // Label doesn't expand
            panel.add(new JLabel(label2), gbc);

            // Field 2
            gbc.gridx = 3;
            gbc.weightx = 1.0;
            gbc.fill = GridBagConstraints.HORIZONTAL;
            field2.setPreferredSize(new java.awt.Dimension(120, 30)); // Fixed field size
            panel.add(field2, gbc);
        }
    }
    
   

    protected void saveDoctorProfile(DoctorTableModel tableModel) {
        String name = nameField.getText().trim();
        String lname=lnameField.getText().trim();
        String contact = contactField.getText().trim();
        String email = emailField.getText().trim();
        String address = addressField.getText().trim();
        String adress2 = adressField2.getText().trim();
        String adress3 = addressField3.getText().trim();
        String pincode = pinField.getText().trim();
        
        String ageText = ageField.getText().trim();
        String qualification = (String)qualificationDropDown.getSelectedItem();
        String department = (String) departmentDropdown.getSelectedItem();
        String specialization = (String) specializationDropdown.getSelectedItem();
        Date startTime = (Date) startTimeSpinner.getValue();
        Date endTime = (Date) endTimeSpinner.getValue();
        List<String> availableDays=new ArrayList<>();
        for(JCheckBox checkBox:dayCheckBoxes) {
        	if(checkBox.isSelected()) {
        		availableDays.add(checkBox.getText());
        	}
        }
        if(availableDays.isEmpty()) {
        	JOptionPane.showMessageDialog(this, "Please select atleast one available day","Validation Error",JOptionPane.ERROR_MESSAGE);
        	return;
        }
        double consultationFee;
        LocalDate dob = dobPicker.getDate()!=null
        		?dobPicker.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
        				:null;
        
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        String formattedStartTime = timeFormat.format(startTime);
        String formattedEndTime = timeFormat.format(endTime);

        if (name.isEmpty() || contact.isEmpty() || email.isEmpty() || address.isEmpty() || ageText.isEmpty() ||
                qualification.isEmpty() || dob==null ) {
            JOptionPane.showMessageDialog(this, "Please fill all fields!", "Validation Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(!contact.matches("\\d{10}")) {
        	JOptionPane.showMessageDialog(this,"Contact must be a 10 digit number!", "Validation Error", JOptionPane.ERROR_MESSAGE); 
        	return; 
        	}
        		  if(!email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
        		  JOptionPane.showMessageDialog(this, "Please enter a valid email address!","Validation Error", JOptionPane.ERROR_MESSAGE); 
        		  return;
        		  }

        try {
            int age = calculateAge(dob);
            
            
            try {
            	consultationFee=Double.parseDouble(consultationFeeField.getText().trim());
            	if(consultationFee<0) {
            		JOptionPane.showMessageDialog(this, "Consultation fee mustbe non negative","Validation error",JOptionPane.ERROR_MESSAGE);
            		return;
            	}
           
            	
            }
            catch(NumberFormatException e){
            	JOptionPane.showMessageDialog(this, "Consultation fee must be valid number","Validation error",JOptionPane.ERROR_MESSAGE);
        		return;
            }
           
            Doctor doctor = new Doctor(name,lname, contact, email, address,adress2,adress3,pincode, dob, age, department, specialization,
                    qualification, formattedStartTime, formattedEndTime, availableDays,consultationFee);
            tableModel.addDoctor(doctor);
            JOptionPane.showMessageDialog(this, "Doctor Profile Saved Successfully!");
            clearFields();
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Age must be a valid number!", "Validation Error", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    protected void updateDoctorProfile(DoctorTableModel tableModel) {
        String name = nameField.getText().trim();
        String lname = nameField.getText().trim();
        String contact = contactField.getText().trim();
        String email = emailField.getText().trim();
        String address = addressField.getText().trim();
        String adress2 = adressField2.getText().trim();
        String adress3 = addressField3.getText().trim();
        String pincode = pinField.getText().trim();
        String ageText = ageField.getText().trim();
        String qualification = (String)qualificationDropDown.getSelectedItem();
        String department = (String) departmentDropdown.getSelectedItem();
        String specialization = (String) specializationDropdown.getSelectedItem();
        Date startTime = (Date) startTimeSpinner.getValue();
        Date endTime = (Date) endTimeSpinner.getValue();
        List<String> availableDays=new ArrayList<>();
        for(JCheckBox checkBox:dayCheckBoxes) {
        	if(checkBox.isSelected()) {
        		availableDays.add(checkBox.getText());
        	}
        }
        if(availableDays.isEmpty()) {
        	JOptionPane.showMessageDialog(this, "Please select atleast one available day","Validation Error",JOptionPane.ERROR_MESSAGE);
        	return;
        }
        double consultationFee;
        LocalDate dob = dobPicker.getDate()!=null
        		?dobPicker.getDate().toInstant().atZone(ZoneId.systemDefault()).toLocalDate()
        				:null;
        
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        String formattedStartTime = timeFormat.format(startTime);
        String formattedEndTime = timeFormat.format(endTime);

        if (name.isEmpty() || contact.isEmpty() || email.isEmpty() || address.isEmpty() || ageText.isEmpty() ||
                qualification.isEmpty() || dob==null ) {
            JOptionPane.showMessageDialog(this, "Please fill all fields!", "Validation Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(!contact.matches("\\d{10}")) {
        	JOptionPane.showMessageDialog(this,"Contact must be a 10 digit number!", "Validation Error", JOptionPane.ERROR_MESSAGE); 
        	return; 
        	}
        		  if(!email.matches("^[\\w.%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
        		  JOptionPane.showMessageDialog(this, "Please enter a valid email address!","Validation Error", JOptionPane.ERROR_MESSAGE); 
        		  return;
        		  }

        try {
            int age = calculateAge(dob);
            
            
            try {
            	consultationFee=Double.parseDouble(consultationFeeField.getText().trim());
            	if(consultationFee<0) {
            		JOptionPane.showMessageDialog(this, "Consultation fee mustbe non negative","Validation error",JOptionPane.ERROR_MESSAGE);
            		return;
            	}
           
            	
            }
            catch(NumberFormatException e){
            	JOptionPane.showMessageDialog(this, "Consultation fee must be valid number","Validation error",JOptionPane.ERROR_MESSAGE);
        		return;
            }
           
            Doctor doctor = new Doctor(name, lname,contact, email, address,adress2,adress3,pincode, dob, age, department, specialization,
                    qualification, formattedStartTime, formattedEndTime, availableDays,consultationFee);
            tableModel.addDoctor(doctor);
            JOptionPane.showMessageDialog(this, "Doctor Profile Saved Successfully!");
            
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, "Age must be a valid number!", "Validation Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void clearFields() {
        nameField.setText("");
        lnameField.setText("");
        contactField.setText("");
        emailField.setText("");
        addressField.setText("");
        adressField2.setText("");
        addressField3.setText("");
        pinField.setText("");
        ageField.setText("");
        qualificationDropDown.setSelectedIndex(0);
        departmentDropdown.setSelectedIndex(0);
        specializationDropdown.setSelectedIndex(0);
        startTimeSpinner.setValue(new SpinnerDateModel().getDate());
        endTimeSpinner.setValue(new SpinnerDateModel().getDate());        
        consultationFeeField.setText("");
        for(JCheckBox checkBox:dayCheckBoxes) {
        	checkBox.setSelected(false);
        }
    }
    private int calculateAge(LocalDate dob) {
    	LocalDate currentDate=LocalDate.now();
    	if(dob!=null&& dob.isBefore(currentDate)) {
    		return Period.between(dob,currentDate).getYears();
    	}
    	return 0;
    }
}
