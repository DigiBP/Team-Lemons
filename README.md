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

![Coop_asis_process](https://user-images.githubusercontent.com/130597830/235457039-e1572102-e334-4030-a572-38056f6bb0f2.png)

## To-be-Process <br />
As mentioned above the to-be-process was defined in meetings with Coop. Withing the meetings it became clear, that the most important aspect is to create an audit compliant and digitizied process. Nevertheless there were some improvements done to the process which are shown in the the following graphic. <br />

![Coop_tobe_process ](https://user-images.githubusercontent.com/130597830/235456996-e2d0b927-c4c4-473d-840d-d61c095a6518.png)

# Digitalization of Process <br />
As already visible in the to-be process, several process steps are to be automated: 
* The process instance starts with the receiption of new credit application. The credit application is filled out using Google Forms, which is connected with Google Sheets. As soon as a new request is submitted, a new row in the Google Sheets is inserted. For each new row, an email to the initiator is sent to confirm the receiption. Lastly, the new application automatically triggers a new process instance and starts the process in Camunda.
![image](https://user-images.githubusercontent.com/127504259/235854898-c886ee63-9be6-464d-a459-12ba72591bc6.png)

