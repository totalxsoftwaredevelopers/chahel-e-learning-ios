import 'package:chahele_project/controller/authentication_provider.dart';
import 'package:chahele_project/controller/image_provider.dart';
import 'package:chahele_project/controller/plan_controller.dart';
import 'package:chahele_project/controller/user_provider.dart';
import 'package:chahele_project/model/user_model.dart';
import 'package:chahele_project/model/user_plan_model.dart';
import 'package:chahele_project/utils/constant_colors/constant_colors.dart';
import 'package:chahele_project/utils/constant_images/constant_images.dart';
import 'package:chahele_project/view/bottom_navigation_bar/bottom_nav_widget.dart';
import 'package:chahele_project/view/profile_tab/widgets/textfield_widget.dart';
import 'package:chahele_project/widgets/button_widget.dart';
import 'package:chahele_project/widgets/cached_network_image.dart';
import 'package:chahele_project/widgets/custom_loading.dart';
import 'package:chahele_project/widgets/custom_toast.dart';
import 'package:chahele_project/widgets/heading_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileSetUp extends StatefulWidget {
  const ProfileSetUp({super.key, required this.phoneNumber, this.editProfile});
  final String phoneNumber;
  final UserPlanModel? editProfile;

  @override
  State<ProfileSetUp> createState() => _ProfileSetUpState();
}

class _ProfileSetUpState extends State<ProfileSetUp> {
  final validateKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.editProfile != null) {
        Provider.of<UserProvider>(context, listen: false)
            .setEditUserData(widget.editProfile!);
        Provider.of<ImagePickProvider>(context, listen: false)
            .editUserImage(widget.editProfile!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final planProvider = Provider.of<PlanController>(context);
    userProvider.phoneNumberController.text = widget.phoneNumber;
    return Scaffold(
        body: CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        HeadingAppBar(
            heading:
                widget.editProfile == null ? "Set Up Profile" : "Edit Profile",
            isBackButtomn: false),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: validateKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Profile Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            customLoading(context, "Saving Image");

                            await imageProvider.pickImage(onFailure: () {
                              Navigator.pop(context);
                            });

                            await imageProvider.saveImage(
                              imageProvider.imageFile!,
                              () {
                                successToast(
                                    context, "Image added successfully");
                              },
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // if (imageProvider.imageUrl ==
                            //     null) {
                            //   log("null");
                            // } else {
                            //   log(imageProvider.imageUrl!);
                            // }
                          },
                          child: imageProvider.imageUrl == null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage(ConstantImage.addUSerImage),
                                )
                              : Container(
                                  clipBehavior: Clip.antiAlias,
                                  height: 140,
                                  width: 140,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: CustomCachedNetworkImage(
                                      image: imageProvider.imageUrl!),
                                ))
                    ],
                  ),
                  const Gap(16),

                  //Name
                  const Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),
                  TextfieldWidget(
                    keyboardType: TextInputType.name,
                    controller: userProvider.nameController,
                    validator: (value) {
                      if (userProvider.nameController.text.isEmpty) {
                        return "Enter your name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const Gap(16),

                  //DOB
                  const Text(
                    "DOB",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ConstantColors.black.withOpacity(0.7)),
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now(),
                            firstDate: DateTime(1950));

                        final formattedDate =
                            DateFormat("dd-MM-yyyy").format(date!);
                        setState(() {});
                        userProvider.dobController.text =
                            formattedDate.toString();
                      },
                      readOnly: true,
                      controller: userProvider.dobController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        fillColor: ConstantColors.white,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ConstantColors.headingBlue, width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                  ),
                  const Gap(16),
                  //Phone number
                  const Text(
                    "Phone Number",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),

                  TextfieldWidget(
                      controller: userProvider.phoneNumberController,
                      readOnly: true),
                  const Gap(16),
                  //Email

                  const Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),

                  TextfieldWidget(
                    controller: userProvider.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => EmailValidator.validate(
                            userProvider.emailController.text)
                        ? null
                        : "Please enter valid email",
                  ),
                  const Gap(16),
                  //Age

                  const Text(
                    "Age",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),

                  TextfieldWidget(
                    controller: userProvider.ageController,
                    keyboardType: TextInputType.number,
                  ),
                  const Gap(16),

                  //Guardian Name

                  const Text(
                    "Guardian Name",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),

                  TextfieldWidget(
                    controller: userProvider.guardianNameController,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(16),
                  //School Name
                  const Text(
                    "School Name",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ConstantColors.headingBlue),
                  ),
                  const Gap(16),

                  TextfieldWidget(
                    controller: userProvider.schoolNameController,
                    keyboardType: TextInputType.name,
                  ),
                  const Gap(16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        buttonColor: ConstantColors.mainBlueTheme,
                        buttonHeight: 42,
                        buttonWidth: 163,
                        buttonText: "Save",
                        onPressed: () async {
                          if (!validateKey.currentState!.validate()) {
                            validateKey.currentState!.validate();
                          } else {
                            // if (imageProvider.imageUrl == null) {
                            //   failedToast(context, "No profile image uploaded");
                            //   return;
                            // }
                            if (userProvider.isLoading == true) {
                              customLoading(
                                  context,
                                  widget.editProfile == null
                                      ? "Creating Profile..."
                                      : "Updating Profile...");
                            }
                            if (widget.editProfile == null) {
                              userProvider.addUserDetails(
                                onFailure: () {
                                  failedToast(context, "Something went wrong");
                                },
                                userModel: UserModel(
                                    createdAt: Timestamp.now(),
                                    id: authProvider
                                        .firebaseAuth.currentUser!.uid,
                                    name: userProvider.nameController.text,
                                    phoneNumber:
                                        userProvider.phoneNumberController.text,
                                    dob: userProvider.dobController.text,
                                    email: userProvider.emailController.text,
                                    age: userProvider.ageController.text,
                                    image: imageProvider.imageUrl,
                                    guardianName: userProvider
                                        .guardianNameController.text,
                                    schoolName:
                                        userProvider.schoolNameController.text,
                                    keywords: userProvider.combinedKeywords(
                                        name: userProvider.nameController.text,
                                        phoneNumber: userProvider
                                            .phoneNumberController.text)),
                                onSuccess: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigationWidget()),
                                      (route) => false);
                                  successToast(
                                      context, "User saved Successfully");
                                },
                              );
                            } else {
                              // Editing existing user profile
                              UserPlanModel updatedProfile = widget.editProfile!
                                  .copyWith(
                                      // Update existing fields
                                      name: userProvider.nameController.text,
                                      phoneNumber: userProvider
                                          .phoneNumberController.text,
                                      dob: userProvider.dobController.text,
                                      email: userProvider.emailController.text,
                                      age: userProvider.ageController.text,
                                      image: imageProvider.imageUrl,
                                      guardianName: userProvider
                                          .guardianNameController.text,
                                      schoolName: userProvider
                                          .schoolNameController.text,
                                      keywords: userProvider.combinedKeywords(
                                          name:
                                              userProvider.nameController.text,
                                          phoneNumber: userProvider
                                              .phoneNumberController.text));

                              userProvider.updateUserDetails(
                                id: authProvider.firebaseAuth.currentUser!.uid,
                                userModel: updatedProfile,
                                onSuccess: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BottomNavigationWidget()),
                                      (route) => false);
                                },
                                onFailure: () {
                                  failedToast(context, "Something went wrong");
                                },
                              );
                            }

                            userProvider.clearFields();
                            imageProvider.clearImage();
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
