import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/core/resources/dimensions.dart';
import 'package:taskflow/features/profile/presentation/manager/my_profile_bloc/my_profile_bloc.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileBloc, MyProfileState>(
      builder: (context, state) {
        if(state is MyProfileInitial){
          context.read<MyProfileBloc>().add(GetMyProfile());
        }
        if(state is MyProfileLoading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(state is MyProfileError){
          return Center(
            child: Text(state.message),
          );
        }
        if(state is MyProfileLoaded){
          return Row(
            children: [
              Image.asset('assets/images/profile.png',height: deviceHeight * 0.1),
              SizedBox(width: deviceWidth * 0.1,),
              Column(
                children: [
                  Text(state.profile.name,style: Theme.of(context).textTheme.titleLarge,),
                  Text(state.profile.email,style: Theme.of(context).textTheme.titleMedium,),
                ],
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
