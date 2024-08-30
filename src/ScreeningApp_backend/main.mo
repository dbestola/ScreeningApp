import Buffer "mo:base/Buffer";
import { toText } "mo:base/Nat";
import Text "mo:base/Text";

actor ApplicantsDatabase {

  type Applicant = {
    name : Text;
    age : Nat;
    yearOfExperience : Nat;
    email : Text;
  };

  var applicantDB = Buffer.Buffer<Applicant>(0);

  let DbHeaders = ["Name", "Age", "yearsOfExperience", "Eligibility"];

  public func registerApplicant(applicant : Applicant) : async Text {
    let _ = applicantDB.add(applicant);
    return "Application Successful, you can go on and check your Eligibility Status";
  };

  public query func getNumberOfapplicants() : async Nat {
    return applicantDB.size();
  };

  public query func getApplicantsMetadata() : async Text {
    var numberOfApplicants = applicantDB.size();
    var numberOfEligibleApplicantsByAge : Nat = 0;
    var numberOfEligibleApplicantsByExperience : Nat = 0;

    let applicantSnapshot = Buffer.toArray(applicantDB);
    for (applicant in applicantSnapshot.vals()) {
      if (applicant.age >= 18) {
        numberOfEligibleApplicantsByAge += 1;
      }
     
    };

   return "Out of " # toText(numberOfApplicants) # " applicants, " #
           toText(numberOfEligibleApplicantsByAge) # " are above 18 years which is the Minimum Requirement for Eligibility" #
           " and " # toText(numberOfEligibleApplicantsByExperience) # " are eligible based on Years of Experience.";
  };

  public query func applicantsEligibleByAge() : async Nat {
    var numberOfEligibleApplicantsByAge : Nat = 0;
    let applicantSnapshot = Buffer.toArray(applicantDB);

    for (applicant in applicantSnapshot.vals()) {
      if (applicant.age >= 18) {
        numberOfEligibleApplicantsByAge += 1;
      }
    };

    return numberOfEligibleApplicantsByAge;
  };

    public query func applicantsEligibleByExperience() : async Nat {
    var numberOfEligibleApplicantsByExperience : Nat = 0;
    let applicantSnapshot = Buffer.toArray(applicantDB);

    for (applicant in applicantSnapshot.vals()) {
      if (applicant.yearOfExperience >= 3) {
        numberOfEligibleApplicantsByExperience += 1;
      }
    };

    return numberOfEligibleApplicantsByExperience;
  };



public query func listOfApplicants_With_EligibilityStatus() : async Text {
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
  for (applicant in applicantSnapshot.vals()) {
    csvText #= applicant.name # ",";
    csvText #= toText(applicant.age) # ",";
    csvText #= toText(applicant.yearOfExperience) # ",";

    let eligibility = if (applicant.age >= 18 and applicant.yearOfExperience >= 3) {
      "eligible"
    } else {
      "not eligible"
    };

    csvText #= eligibility # "\n";
  };
  return csvText;
};

};


