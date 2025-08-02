<script lang="ts" setup>
import { ElMessage, type FormInstance, type FormRules } from "element-plus";
import {
  getCaptcha,
  getEmailCaptcha,
  getSmsCaptcha,
  register,
  registerByEmail,
  registerBySms,
} from "@/api/member/member";

interface RuleForm {
  username: string;
  password: string;
  email: string;
  mobile: string;
  captcha: string;
  captchaId: string;
  rePassword: string;
}

const memberInfo = reactive<RuleForm>({
  username: "",
  password: "",
  email: "",
  mobile: "",
  captcha: "",
  captchaId: "",
  rePassword: "",
});

const captchaImgSrc = ref<string>();
const registerType = ref<string>("captcha");
const sendCaptchaMsg = ref<string>("member.sendCaptcha");
const totalTime = ref<number>(60);
const canClick = ref<boolean>(false);
const ruleFormRef = ref<FormInstance>();
const { t } = useI18n();
const rules = reactive<FormRules<RuleForm>>({
  username: [
    { required: true, message: t("member.requiredUsername"), trigger: "blur" },
    { min: 3, max: 20, message: t("member.ruleUsername"), trigger: "blur" },
  ],
  password: [
    { required: true, message: t("member.requiredPassword"), trigger: "blur" },
    { min: 6, max: 20, message: t("member.rulePassword"), trigger: "blur" },
  ],
  email: [
    { required: true, message: t("member.requiredEmail"), trigger: "blur" },
    {
      type: "email",
      message: t("member.ruleEmail"),
      trigger: ["blur", "change"],
    },
  ],
  mobile: [
    { required: true, message: t("member.requiredMobile"), trigger: "blur" },
    {
      pattern: /^1[3|4|5|7|8][0-9]\d{8}$/,
      message: t("member.ruleMobile"),
      trigger: "blur",
    },
  ],
  captcha: [
    { required: true, message: t("member.requiredCaptcha"), trigger: "blur" },
    { min: 5, max: 5, message: t("member.ruleCaptcha"), trigger: "blur" },
  ],
});

const isEmailOrSms = computed(() => {
  if (registerType.value === "captcha") {
    return false;
  } else {
    return true;
  }
});

function getCaptchaData() {
  getCaptcha()
    .then((data) => {
      if (data.code === 0) {
        captchaImgSrc.value = data.data.imgPath;
        memberInfo.captchaId = data.data.captchaId;
      } else {
        ElMessage({
          message: data.msg,
          type: "error",
        });
      }
    })
    .catch((e) => {
      ElMessage({
        message: e,
        type: "error",
      });
    });
}

function getEmailOrSmsCaptcha(formEl: FormInstance | undefined) {
  if (registerType.value === "email") {
    // 发送邮箱验证码
    formEl
      ?.validateField("email")
      .then(() => {
        if (canClick.value) return;
        canClick.value = true;
        sendCaptchaMsg.value = totalTime.value + "s";
        const clock = window.setInterval(() => {
          totalTime.value--;
          sendCaptchaMsg.value = totalTime.value + "s";
          if (totalTime.value < 0) {
            window.clearInterval(clock);
            sendCaptchaMsg.value = "member.sendCaptcha";
            totalTime.value = 10;
            canClick.value = false;
          }
        }, 1000);

        getEmailCaptcha(memberInfo.email).then((data) => {
          if (data.code !== 0) {
            ElMessage({
              message: data.msg,
              type: "error",
            });
          } else {
            ElMessage({
              message: t("member.sendCaptchaSuccess"),
              type: "success",
            });
          }
        });
      })
      .catch(() => {
        ElMessage({
          message: t("member.emailError"),
          type: "error",
        });
      });
  } else if (registerType.value === "mobile") {
    // 发送手机验证码
    if (canClick.value) return;
    canClick.value = true;
    sendCaptchaMsg.value = totalTime.value + "s";
    const clock = window.setInterval(() => {
      totalTime.value--;
      sendCaptchaMsg.value = totalTime.value + "s";
      if (totalTime.value < 0) {
        window.clearInterval(clock);
        sendCaptchaMsg.value = "member.sendCaptcha";
        totalTime.value = 10;
        canClick.value = false;
      }
    }, 1000);

    formEl
      ?.validateField("mobile")
      .then(() => {
        getSmsCaptcha(memberInfo.mobile).then((data) => {
          if (data.code !== 0) {
            ElMessage({
              message: data.msg,
              type: "error",
            });
          } else {
            ElMessage({
              message: t("member.sendCaptchaSuccess"),
              type: "success",
            });
          }
        });
      })
      .catch(() => {
        ElMessage({
          message: t("member.mobileError"),
          type: "error",
        });
      });
  }
}

function Submit(formEl: FormInstance | undefined) {
  formEl?.validate().then(() => {
    if (memberInfo.password !== memberInfo.rePassword) {
      ElMessage({
        message: t("member.passwordNotSame"),
        type: "error",
      });
      return;
    }

    if (registerType.value === "captcha") {
      register({
        username: memberInfo.username,
        password: memberInfo.password,
        captcha: memberInfo.captcha,
        captchaId: memberInfo.captchaId,
        email: memberInfo.email,
      })
        .then((data) => {
          if (data.code === 0) {
            ElMessage({
              message: data.msg,
              type: "success",
            });

            navigateTo("/member/login");
          } else {
            ElMessage({
              message: data.msg,
              type: "error",
            });
          }
        })
        .catch(() => {
          ElMessage({
            message: t("member.registerError"),
            type: "error",
          });
        });
    } else if (registerType.value === "email") {
      registerByEmail({
        username: memberInfo.username,
        password: memberInfo.password,
        captcha: memberInfo.captcha,
        email: memberInfo.email,
      })
        .then((data) => {
          if (data.code === 0) {
            ElMessage({
              message: data.msg,
              type: "success",
            });

            navigateTo("/member/login");
          } else {
            ElMessage({
              message: data.msg,
              type: "error",
            });
          }
        })
        .catch(() => {
          ElMessage({
            message: t("member.registerError"),
            type: "error",
          });
        });
    } else {
      registerBySms({
        phoneNumber: memberInfo.mobile,
        captcha: memberInfo.captcha,
        username: memberInfo.username,
        password: memberInfo.password,
      })
        .then((data) => {
          if (data.code === 0) {
            ElMessage({
              message: data.msg,
              type: "success",
            });

            navigateTo("/member/login");
          } else {
            ElMessage({
              message: data.msg,
              type: "error",
            });
          }
        })
        .catch(() => {
          ElMessage({
            message: t("member.registerError"),
            type: "error",
          });
        });
    }
  });
}

onMounted(() => {
  getCaptchaData();
});
</script>

<template>
  <NuxtLayout>
    <el-row>
      <el-col :span="10" :offset="7">
        <el-card>
          <el-form
            ref="ruleFormRef"
            :rules="rules"
            label-position="top"
            :model="memberInfo"
          >
            <el-form-item>
              <el-row justify="center" class="w-full">
                <el-col :span="12" class="text-center">
                  <h1>{{ $t("member.register") }}</h1></el-col
                >
              </el-row>
            </el-form-item>
            <el-form-item>
              <el-radio-group v-model="registerType" size="large">
                <el-radio-button label="captcha">{{
                  $t("member.captcha")
                }}</el-radio-button>
                <el-radio-button label="email">{{
                  $t("member.email")
                }}</el-radio-button>
                <el-radio-button label="mobile">{{
                  $t("member.mobile")
                }}</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-form-item :label="$t('member.username')" prop="username">
              <el-input
                v-model="memberInfo.username"
                :placeholder="$t('member.requiredUsername')"
              />
            </el-form-item>
            <el-form-item
              v-if="registerType !== 'mobile'"
              :label="$t('member.email')"
              prop="email"
            >
              <el-input
                v-model="memberInfo.email"
                :placeholder="$t('member.requiredEmail')"
              />
            </el-form-item>
            <el-form-item
              v-if="registerType === 'mobile'"
              :label="$t('member.mobile')"
              prop="mobile"
            >
              <el-input
                v-model="memberInfo.mobile"
                :placeholder="$t('member.requiredMobile')"
              />
            </el-form-item>
            <el-form-item :label="$t('member.password')" prop="password">
              <el-input
                v-model="memberInfo.password"
                :placeholder="$t('member.requiredPassword')"
                type="password"
              />
            </el-form-item>
            <el-form-item :label="$t('member.reEnterPassword')" prop="password">
              <el-input
                v-model="memberInfo.rePassword"
                :placeholder="$t('member.requiredPassword')"
                type="password"
              />
            </el-form-item>
            <el-form-item
              v-if="!isEmailOrSms"
              :label="$t('member.captcha')"
              prop="captcha"
            >
              <el-input
                v-model="memberInfo.captcha"
                :placeholder="$t('member.requiredCaptcha')"
              >
                <template #append>
                  <el-image
                    :src="captchaImgSrc"
                    fit="fill"
                    style="max-width: 150px"
                    @click="getCaptchaData()"
                  ></el-image>
                </template>
              </el-input>
            </el-form-item>
            <el-form-item
              v-if="isEmailOrSms"
              :label="$t('member.captcha')"
              prop="captcha"
            >
              <el-row class="w-full">
                <el-col :span="15">
                  <el-input
                    v-model="memberInfo.captcha"
                    :placeholder="$t('member.requiredCaptcha')"
                  >
                  </el-input>
                </el-col>
                <el-col :span="8" :offset="1">
                  <el-button
                    type="default"
                    class="w-full"
                    :disabled="canClick"
                    @click="getEmailOrSmsCaptcha(ruleFormRef)"
                    >{{ $t(sendCaptchaMsg) }}</el-button
                  >
                </el-col>
              </el-row>
            </el-form-item>
            <el-form-item>
              <el-row justify="center" class="w-full">
                <el-col :span="24">
                  <el-button
                    type="primary"
                    class="w-full"
                    @click="Submit(ruleFormRef)"
                    >{{ $t("member.register") }}</el-button
                  ></el-col
                >
              </el-row>
              <el-row justify="center" class="w-full mt-2">
                <el-col :span="24">
                  <el-button
                    type="default"
                    class="w-full"
                    @click="navigateTo('/member/login')"
                    >{{ $t("member.login") }}</el-button
                  ></el-col
                >
              </el-row>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </NuxtLayout>
</template>

<style scoped></style>
