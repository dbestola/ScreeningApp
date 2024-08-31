import Buffer "mo:base/Buffer";
import { toText } "mo:base/Nat";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor ApplicantsDatabase {

  type Applicant = {
    fullName : Text;
    age : Nat;
    yearsOfExperience : Nat;
    email : Text;
    portfolioURL : Text;
    currentSalary : Text;
    expectedSalary : Text;
    noticePeriod : Text;
  };

  var applicantDB = Buffer.Buffer<Applicant>(0);

  let DbHeaders = ["Name", "Age", "yearsOfExperience", "Eligibility"];

  public func registerApplicants(applicant : Applicant) : async Text {
    let _ = applicantDB.add(applicant);
    return "Application Successful, Proceed to check your Eligibility Status";
  };

  public query func getNumberOfapplicants() : async Nat {
    return applicantDB.size();
  };

  public query func getApplicantsMetadata() : async Text {
    var numberOfApplicants = applicantDB.size();
    var numberOfEligibleApplicantsByAge : Nat = 0;
    var numberOfEligibleApplicantsByExperience : Nat = 0;

    let applicantSnapshot = Buffer.toArray(applicantDB);
    for (applicants in applicantSnapshot.vals()) {
      if (applicants.age >= 18) {
        numberOfEligibleApplicantsByAge += 1;
      };

      if (applicants.yearsOfExperience >= 3) {
        numberOfEligibleApplicantsByExperience += 1;
      };

    };

    return "Out of " # toText(numberOfApplicants) # " applicants that registered, " #
    toText(numberOfEligibleApplicantsByAge) # " applicants meet the required age of 18 years and above" #
    " and " # toText(numberOfEligibleApplicantsByExperience) # " applicants has at least 3 years of Experience which is also a requirement for Qualification to the next Stage.";
  };

  public query func getApplicantsEligibleByAge() : async Nat {

    var numberOfEligibleApplicantsByAge : Nat = 0;

    let applicantSnapshot = Buffer.toArray(applicantDB);

    for (applicants in applicantSnapshot.vals()) {
      if (applicants.age >= 18) {
        numberOfEligibleApplicantsByAge += 1;
      };
    };

    return numberOfEligibleApplicantsByAge;
  };

  public query func getApplicantsEligibleByExperience() : async Nat {

    var numberOfEligibleApplicantsByExperience : Nat = 0;

    let applicantSnapshot = Buffer.toArray(applicantDB);

    for (applicants in applicantSnapshot.vals()) {
      if (applicants.yearsOfExperience >= 3) {
        numberOfEligibleApplicantsByExperience += 1;
      };
    };

    return numberOfEligibleApplicantsByExperience;
  };

  public query func getEligibilityList() : async Text {
    var csvText = "";

    for (index in DbHeaders.keys()) {
      let header = DbHeaders[index];

      if (index == DbHeaders.size() - 1) {
        csvText #= header # "\n";
      } else {
        csvText #= header # ",";
      };
    };

    let applicantSnapshot = Buffer.toArray(applicantDB);
    for (applicants in applicantSnapshot.vals()) {
      csvText #= applicants.fullName # ",";
      csvText #= toText(applicants.age) # ",";
      csvText #= toText(applicants.yearsOfExperience) # ",";

      let eligibility = if (applicants.age >= 18 and applicants.yearsOfExperience >= 3) {
        "Congratulations..! you are Eligible";
      } else {
        "Sorry..! you are not Eligible";
      };

      csvText #= eligibility # "\n";
    };
    return csvText;
  };

};
