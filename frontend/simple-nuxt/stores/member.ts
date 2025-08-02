import { defineStore } from "pinia";
import type { MemberInfo } from "~/api/member/model/memberModel";

export const useMemberStore = defineStore("member", {
  state: () => {
    return {
      nickname: "",
      token: "",
      avatar: "",
      expire: 0,
      rankId: 0,
      rankName: "",
    };
  },
  actions: {
    login(data: MemberInfo) {
      this.nickname = data.nickname;
      this.token = data.token;
      if (
        data.avatar !== undefined &&
        data.avatar !== null &&
        data.avatar !== ""
      ) {
        this.avatar = data.avatar;
      } else {
        this.avatar = "/images/logo.svg";
      }
      this.expire = data.expire;
      this.rankId = data.rankId;
      this.rankName = data.rankName;
    },
    logout() {
      this.nickname = "";
      this.token = "";
      this.avatar = "";
      this.expire = 0;
      this.rankId = 0;
      this.rankName = "";

      navigateTo("/");
    },
  },
  persist: true,
});
