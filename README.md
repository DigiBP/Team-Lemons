# :lemon: Team-Lemons :lemon:

# Team members <br />
* Anojan Arunasalam<br />
* Bosko Simic<br />
* Noah Bechler<br />
* Seline Wenger<br />

# Introduction <br />
This document describes the credit approval process at the Coop Group and how it is digitized.<br />

Coop dedicates a certain amount of money for each project running currently and in the future. Therefore, project managers and their teams have a fund to finance their projects with. This fund is regulated by the project manager him-/herself and the responsible line managers. Depending on how much money the team is requesting for a task, there are certain approval procedures that must be adhered to.<br />

The team "Lemons" will simplify and digitalize the current process for Coop and build a prototype within Camunda and Make.<br />

# Process Design <br />
In the following chapter the process design of the as-is-process and the to-be-process will be described. The to-be-process was defined in meetings with Coop. <br />

## As-Is-Process <br />
In the as-is-process the person submitting the credit application was filling out a word form which must be printed out and later on sent to different participants depending on the project and actual amount of the credit which was asked for. <br />

Since the process is paper-based and not digital, the document must be sent to the respective approvers via in-house mail.<br />

The course of the process is based on the project managers and the management levels to be involved, depending on the amount requested. The approval process always has 3 approvers, the first two of which are determined from the data of the selected project. The sub-project manager and the project manager are always involved.<br />
In reality, there is often a deviation from the predefined process flow, which leads to competence regulations not being respected. As a result, problems with the internal audit team can arise at a later stage. <br />

A clear disadvantage of the current process is, that it is not transparent at what stage of approval the process currently is. <br />


![Coop_as-is_process](https://github.com/DigiBP/Team-Lemons/assets/127504259/2918f95d-26d7-43e6-8139-100e21d7506e)


## To-be-Process <br />
As mentioned above the to-be-process was defined in meetings with Coop. Withing the meetings it became clear, that the most important aspect is to create an audit compliant and digitizied process. Nevertheless there were some improvements done to the process which are shown in the the following graphic. <br />

![Coop_to-be_process](https://github.com/DigiBP/Team-Lemons/assets/127504259/87b4ceb3-8a4e-49a5-bb02-1b1e40a48885)


![Coop_tobe_process_Subprocess](https://github.com/DigiBP/Team-Lemons/assets/127504259/0fb53a2f-b3f4-424b-85ca-4d44539be658)

## Description of the to-be process steps
In the following the process steps of the to-be process are explained. 
* The credit applicant fills out the credit request form with the amount of money required for a specific process and submits the   request
* The first approver (sub-project manager) will decline or accept the request.
  * The information about the first approver is stored in the project database.
* The second approver (project manager) will decline or accept the request.
   * The information about the second approver is stored in the project database.
* The third approver is chosen depending on the amount of money requested by the credit applicant. 
  * The DMN Model created by the group will decide which management level will be requried to accept or decline the request. 
* After the third approval the information about the credit will be forwarded to the accounting department where it will be processes and updated in the SAP system.

# Digitalization of Process <br />
As already visible in the to-be process, several process steps are to be automated: 
* **Message Start Event (iSaaS):** The process instance starts with the receiption of new credit application. The credit application is filled out using Google Forms, which is connected with Google Sheets. As soon as a new request is submitted, a new row in the Google Sheets is inserted. For each new row, an email to the initiator is sent to confirm the receiption. To ensure that the email is sent just once, the row is updated with Email sent = yes. Only for rows where Email sent = null Emails will be sent. Lastly, the new application automatically triggers a new process instance and starts the process in Camunda.
![image](https://user-images.githubusercontent.com/127504259/235854898-c886ee63-9be6-464d-a459-12ba72591bc6.png)
* **Get Project Details:** The application form is to be enriched with further project information such as the project's name and the (sub-)project manager as well as information about the initiator. This data has to be requested from the database. For this project, a database within mySQL with the tables "employees" and "Projects" is created:
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/195451a6-3167-4373-9b82-2ec0dee45a66)
  * **Get additional information (iSaaS)**: A service task that is called . 
 ![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/39bbbc7f-266a-434d-bac6-da944e1dfdfa)

  * **Error Handling**: in case that the project cannot be identified, an error handling task is required. Without knowing the sub-project-manager and/or the project manager the process could not be moved forward. Thus, an Intermediate Event Interrupting is attached to the service task to handle this error. In this case, the backoffice has to contact the initiator to clarify the project details and to correct the form. 
* **Decide on ML Level for Third Approver (DMN):** In the decision requirements diagram the overview on how to decide on the ML Level for the third approver is shown. In a frist step, the amount of the credit as well as the fact whether the credit was budgeted or not are used as input, resulting into the required ML Level of the third approver. This output variable is used as an input for the second decision model, where also the ML Level of the initiator is considered. Meaning, if the ML Level of the initiator is equal or above the ML Level of the third approver, the third approval can be dispensed. As the unique hit rule is applied, each combination will lead to a unique, unambiguous output. 

![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/8df4b4f6-0487-4065-8178-d86cb6891cde)
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/2c613dee-844f-4264-9718-fb5e76ee7b49)
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/a889e7aa-1f6f-468a-a165-4fab5cea044c)

* **Get Approver 3 (iSaaS)**: After the DMN returned the ML Level of the thrid approver, the user behind this ML Level can be identified. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/98e32f67-05b5-48d8-b26b-149dc9791585)


* **Send Request for Approval (iSaaS):** For each approver, a approval request is sent per email. In the email, HTML buttons are provided to either decline or approve a credit application. These buttons contain links that access a Google Apps Script web app URL. This URL is further enriched with additional parameters regarding the credit application. Upon clicking, the JavaScript code within the web app is executed, saving the record in a Google Sheets table.<br />
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/0d8a8715-4250-4abb-95da-44fff0197cd0)
<br />
Email for Approval Request: <br />
![Approval_Request](https://github.com/DigiBP/Team-Lemons/assets/127504259/3d637c57-32a8-4e4c-a31c-dced4de17ea8)
JavaScript for Approve Button: <br />
![Approval_Script](https://github.com/DigiBP/Team-Lemons/assets/127504259/07f910eb-5b87-462b-a9d5-8307ce2d9248)
JavaScript for Reject Button: <br />
![Rejection_Script](https://github.com/DigiBP/Team-Lemons/assets/127504259/3a51aee5-65ed-4b06-97ad-82e99dbbc469)





# Outlook
