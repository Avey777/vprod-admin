export interface MemberInfo {
  avatar: string;
  expire: number;
  nickname: string;
  rankId: number;
  rankName: string;
  token: string;
  userId: string;
}

export interface MemberLoginReq {
  username: string;
  password: string;
  captchaId: string;
  captcha: string;
}

export interface CaptchaInfo {
  captchaId: string;
  imgPath: string;
}

export interface LoginReq {
  captcha: string;
  captchaId: string;
  password: string;
  username: string;
}

export interface LoginByEmailReq {
  captcha: string;
  email: string;
}

export interface LoginBySmsReq {
  captcha: string;
  phoneNumber: string;
}

export interface RegisterReq {
  captcha: string;
  captchaId?: string;
  email?: string;
  password: string;
  username: string;
  phoneNumber?: string;
}
