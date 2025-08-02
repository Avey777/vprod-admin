import type { BaseDataResp, BaseResp } from "../base/model/baseModel";
import type {
  CaptchaInfo,
  LoginByEmailReq,
  LoginBySmsReq,
  LoginReq,
  MemberInfo,
  RegisterReq,
} from "./model/memberModel";

export enum Api {
  Login = "/mms-api/member/login",
  LoginByEmail = "/mms-api/member/login_by_email",
  LoginBySms = "/mms-api/member/login_by_sms",
  LoginByWechatMini = "/mms-api/oauth/login/wechat/mini_program",
  Captcha = "/mms-api/captcha",
  EmailCaptcha = "/mms-api/captcha/email",
  SmsCaptcha = "/mms-api/captcha/sms",
  UpdateProfile = "/mms-api/member/profile",
  Logout = "/mms-api/member/logout",
  Register = "/mms-api/member/register",
  RegisterByEmail = "/mms-api/member/register_by_email",
  RegisterBySms = "/mms-api/member/register_by_sms",
  TestVip = "/mms-api/member/vip",
}

export const getCaptcha = () => xFetch<BaseDataResp<CaptchaInfo>>(Api.Captcha);

export const getEmailCaptcha = (email: string) =>
  xFetch<BaseResp>(Api.EmailCaptcha, { body: { email }, method: "POST" });

export const getSmsCaptcha = (phone: string) =>
  xFetch<BaseResp>(Api.SmsCaptcha, {
    body: { phoneNumber: phone },
    method: "POST",
  });

export const login = (params: LoginReq) =>
  xFetch<BaseDataResp<MemberInfo>>(Api.Login, { body: params, method: "POST" });

export const loginByEmail = (params: LoginByEmailReq) =>
  xFetch<BaseDataResp<MemberInfo>>(Api.Login, { body: params, method: "POST" });

export const loginBySms = (params: LoginBySmsReq) =>
  xFetch<BaseDataResp<MemberInfo>>(Api.Login, { body: params, method: "POST" });

export const register = (params: RegisterReq) =>
  xFetch<BaseResp>(Api.Register, {
    body: params,
    method: "POST",
  });

export const registerByEmail = (params: RegisterReq) =>
  xFetch<BaseResp>(Api.RegisterByEmail, {
    body: params,
    method: "POST",
  });

export const registerBySms = (params: RegisterReq) =>
  xFetch<BaseResp>(Api.RegisterBySms, {
    body: params,
    method: "POST",
  });

export const testVip = () => xFetch<BaseResp>(Api.TestVip, { method: "GET" });
