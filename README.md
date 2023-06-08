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
<br />

![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/09cd92b7-76ec-42a9-94b3-0779cbdb6e7c)
<br />

# Process Design <br />
In the following chapter the process design of the as-is-process and the to-be-process will be described. The to-be-process was defined in meetings with Coop. <br />

## As-Is-Process <br />
In the as-is-process the person submitting the credit application was filling out a word form which must be printed out and later on send to different participants depending on the project and actual amount of the credit which was asked for. <br />

Since the process is paper-based and not digital, the document must be send to the respective approvers via in-house mail.<br />

The course of the process is based on the project managers and the management levels to be involved, depending on the amount requested. The approval process always has 3 approvers, the first two of which are determined from the data of the selected project. The sub-project manager and the project manager are always involved.<br />
In reality, there is often a deviation from the predefined process flow, which leads to competence regulations not being respected. As a result, problems with the internal audit team can arise at a later stage. <br />

A clear disadvantage of the current process is, that it is not transparent at what stage of approval the process currently is at. <br />

:x: Paper-based processes without automation. <br />
:x: Decision logic to determine third Approver is not documented and is defined manually.<br />
:x: Process is error prone as decision logic is not made explicit.<br />
:x: Lack of traceability during the various stages of the process.<br />
:x: Lack of traceability prior to internal audit. <br />
:x: Long lead times due to the absence of standardization.<br />


![Coop_as-is_process](https://github.com/DigiBP/Team-Lemons/assets/127504259/2918f95d-26d7-43e6-8139-100e21d7506e)


## To-be-Process <br />
As mentioned above the to-be-process was defined in meetings with Coop. Within the meetings it became clear, that the most important aspect is to create an audit compliant and digitizied process. Nevertheless there were some improvements done to the process which are shown in the the following graphic. <br />

**To-Be Process** 
![Coop_to-be_process](https://github.com/DigiBP/Team-Lemons/assets/127504259/87b4ceb3-8a4e-49a5-bb02-1b1e40a48885)

**Subprocess "Request Project Information"**
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
* After the third approval the information about the credit will be forwarded to the accounting department where it will be processed and updated in the SAP system.

# Digitalization of Process <br />
As already visible in the to-be process, several process steps are to be automated: 
## Message Start Event (MAKE Scenario 1) <br />
The process  starts with the receiption of new credit application. The credit application is filled out using Google Forms, which is connected with Google Sheets. As soon as a new request is submitted, a new row in the Google Sheets is inserted. For each new row, an email to the initiator is sent to confirm the receiption. To ensure that the email is sent just once, only for rows where Email sent = null emails will be sent. After executing the gmail module, the row is updated with email sent = "yes". Lastly, a HTTP request to the Camunda message "creditRequestCreated" is sent to Camunda to trigger a new process instance. This requests includes the varibales of the form and the indication of a unique business key.<br />
![image](https://user-images.githubusercontent.com/127504259/235854898-c886ee63-9be6-464d-a459-12ba72591bc6.png)

**Google Forms:**<br />
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/6f8b92d7-ec74-4336-ac10-ac1e00fdd0e5)

**Google Sheets for Form Responses:**<br />
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/2f7f03b1-6fe5-48a9-b01d-8a68cd3f286d)


## Get Project Details (MAKE Scenario 2) <br />
The application form is to be enriched with further project information such as the project's name and the (sub-)project manager as well as information about the initiator. This data has to be requested from the database. For this project, a database within mySQL is created:<br />
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/2066d55c-498f-40e6-87db-698aae902997)
 ### Get additional information<br />
From the variables of the initial request, further information out of the database can be added. Since this task is performed by an external worker, a REST API call of the form fetch and lock is made, subscribed to a specific topic. The worker selects the row for whose request no enrichment has yet taken place (Project Details = null). On the one hand, more information about the initiator is requested (mySQL Table dim_Employees), on the other hand, information about the project in question is retrieved (mySQL Table dim_Projects). After successful enrichment, the Project Details cell is updated to "yes" and the task is marked as completed by sending an API REST request back to Camunda. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/68a80eea-2c76-4393-af1d-9c2a57c6ed21)

 ### Error Handling<br />
If no entry for the project is found in the database, an error handling task is required. Without knowing the subproject manager and/or the project manager of the project,  the process cannot be continued. Thus, an intermediate event interruption is attached to the service task to handle this error. In this case, the back office must contact the initiator to clarify the project details and correct the form. 
To trigger this error event, a router a router has been added to the MAKE scenario. If the project ID does not exists in the mySQL database, a REST API request to the BPMN error message event is sent back to Camunda. 

## Decide on ML Level for Third Approver (DMN)<br />
In the decision requirements diagram the overview on how to decide on the ML Level for the third approver is shown. In a frist step, the amount of the credit as well as the fact whether the credit was budgeted or not are used as input, resulting into the required ML Level of the third approver. This output variable is used as an input for the second decision model, where also the ML Level of the initiator is considered. Meaning, if the ML Level of the initiator is equal or above the ML Level of the third approver, the third approval can be dispensed. As the unique hit rule is applied, each combination will lead to a unique, unambiguous output. 

![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/8df4b4f6-0487-4065-8178-d86cb6891cde)
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/2c613dee-844f-4264-9718-fb5e76ee7b49)
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/a889e7aa-1f6f-468a-a165-4fab5cea044c)

## Get Approver 3 (MAKE Scenario 3)<br />
After the DMN task returned the ML Level of the thrid approver, the user behind this ML Level can be identified. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/98e32f67-05b5-48d8-b26b-149dc9791585)

## Send Request for Approval (MAKE Scenarios 4, 7, 10)<br />
For each approver, an approval request is sent per email. In the email, HTML buttons are provided to either decline or approve a credit application. These buttons contain links that access a Google Apps Script web app URL. This URL is further enriched with additional parameters regarding the credit application. Upon clicking, the JavaScript code within the web app is executed, saving the record in a Google Sheets table.<br />
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/0d8a8715-4250-4abb-95da-44fff0197cd0)
<br />
<br />
**Email for Approval Request:** <br />
![Approval_Request](https://github.com/DigiBP/Team-Lemons/assets/127504259/3d637c57-32a8-4e4c-a31c-dced4de17ea8)
<br />
**JavaScript for Approve Button:** <br />
![Approval_Script](https://github.com/DigiBP/Team-Lemons/assets/127504259/07f910eb-5b87-462b-a9d5-8307ce2d9248)
**JavaScript for Reject Button:** <br />
![Rejection_Script](https://github.com/DigiBP/Team-Lemons/assets/127504259/3a51aee5-65ed-4b06-97ad-82e99dbbc469)

## Get Approval Decision (MAKE Scenarios 5, 8, 12)<br />
As described in the previous step, each approval decision is recorded as a new row in a Google Sheet after clicking the corresponding HTML button. In MAKE, a Google Sheets module is watching for new rows, and to reduce errors, is filtering to rows that are not yet processed (sent = null). After the right row is selected, the decision is also written in our fact table of the mySQL database table fct_Approval. It then updates the Google Sheets cell with sent = yes. Afterwards, a HTTP request is sent back to the Camunda Process instance which completes the intermediate message event. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/92ef4117-6934-4d0d-8d39-c03b9c7fb91d)<br />
<br />
**Google Sheets for Decision**
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/e4e7c0ae-80ff-4c10-a5da-418f6f42f7e6)


## Send Rejection to Initiator (MAKE Scenarions 6, 9, 13)<br />
If the approval decision is negative, the initiator must be informed about this decision. In this case, the process is ended without applying for further approvals. This task is once again executed by an external worker using a REST API call of the form fetch and lock that is subscribed to a specific topic. The name of the decision maker is inserted into the mail to the initiator by querying the MySQL database, so that the requester can contact the decision maker in case of questions. After the task is completed, an API REST request is sent back to Camunda. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/d22cd551-9a87-4fbd-bd95-dcf0f9acb5ae)

## Send Reminder to Approver 3 (MAKE Scenario 11)<br />
After the approval decision of the third approver has been requested, the process reaches an event-based gateway. If two working days pass without an approval decision being obtained in the form of an intermediate message catch event, the third approver must be reminded by e-mail. An REST API call of the form fetch and lock is performed. At this stage, the employee information of the third approver is queried from the MySQL database and the approval decision mail has to be sent again. After the task is completed, an API REST request is sent back to Camunda. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/cf48d6ab-17b4-4848-8127-ebde3c5cea9c)

## Notify Accounting (MAKE Scenario 14)<br />
As soon as all decision-makers have approved the request, the accounting department must be informed of the decision. Since the accounting team has a fixed group mailbox, the scenario does not need a connection to the mySQL database. 

![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/73f14a98-f876-4382-972c-d73adfa8d4bc)

## Call Activity to Change the SAP Status
After the accounting team is notified, a call activity is performed. This is a process that is performed by the back office team. To illustrate this step in our prototype, a simple user task is added that needs to be claimed and completed in Camunda. 

![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/3ca50a99-cf5c-4f63-afaf-6d075401ea96)


## Send Confirmation to Initiator (MAKE Scenario 15)<br />
Obviously, also the initiator has to be informed about the positive decision. Thereby, a last MAKE Scenario is needed to send an email with the confirmation to the applicant. Since the email adress of the appliant is already stored as a process variable, no connection to the mySQL database is needed. After the external worker marks this step as completed, the process is ended. 
![image](https://github.com/DigiBP/Team-Lemons/assets/127504259/a0f1d123-3d99-4f4c-a452-41572a73c789)

# Innovation
To incorporate innovation into the workflow, the team trained an algorithm that predicts whether the request is likely to be approved or denied based on previous requests.  <br />

To make the prediction, sample data sets are needed to train the model. The data needed for this comes from the MySQL table fct_Approval. This table holds all approvals from all levels. However, only the last instance is relevant for the prediction, so the table is modified for Aito.ai and only the necessary data rows are uploaded. After uploading the data to Aito.ai, a schema must be defined. For each column it must be decided what the data type is and if it is needed for the prediction. <br />

In our case the following columns were relevant for the prediction:
* Answer
* Budgeted
* Approver
* Credit Amount



# Benefits
This chapter will give a short summary of the benefits of our solution. <br />

The team created an automated funding request system that is able to streamline the funding approval process, eliminate manual paperwork and reduce inefficiencies. The digital platform provides real-time visibility of the approval status to all stakeholders involved in the process.
The data validation mechanisms and automated calculations within the funding request helps users to minimalize errors and to ensure accurate financial information. 
The implementation of a clearly defined approval workflows and automated notifications for the request approvers reduces the runtime of the process and delays in the funding allocation. Our standardized templates and guidelines ensure comparability and efficiency of the requests. 

# Outlook
In the following an outlook about possible enhancements of the process will be given. <br />

A small optimization that could be done is to further streamline the process. If allowed by interal audit the approval of one of the project managers could be left out. Consequently the approval run time could be shortened and the money needed for the project could be released faster. <br />

The processes could be improved with certain automations. One of these automations could be an update of the credit status in the SAP system after the credit approval processes is finished. Therefore an interface between the approval workflow and the SAP system would need to be established. The interface could then give the information about the credit amount and person responsible to the SAP system, where the data could be updated and stored. <br />

Given the rise of chatbots it could also be a possibility to build a chatbot where employees could insert some keywords and the bot would start the credit approval process automatically. Those keywords would need to contain the project name, the amount of money required and the reason why the credit is needed. <br />
